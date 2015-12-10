#!/usr/bin/python

import argparse
import cStringIO
import re
import sys

def ParseArgs():
  parser = argparse.ArgumentParser(
description="""Convert from the "flat" text
assembly syntax emitted by LLVM into the s-expression syntax expected by
the spec repository. Perform fake linking so that symbols can be
resolved. This currently only works on single-file programs. Note: this is
a hack. A real toolchain will eventually be needed.""")
  parser.add_argument('-o', '--output', type=str, default=None,
                      help='output `.wasm` s-expression file')
  parser.add_argument('input', metavar='INPUT', nargs='?',
                      help='input `.s` LLVM assembly file')
  return parser.parse_args()

def readInput(input_file):
  """Read LLVM input from the file specified, or stdin."""
  if input_file is None:
    return sys.stdin.read().splitlines()
  return open(input_file, 'rb').readlines()

class OutputWriter(object):
    def __init__(self):
        self.current_indent = ''
        self.dirty = False
        self.out = cStringIO.StringIO()

    def indent(self):
        assert not self.dirty
        self.current_indent += '  '

    def dedent(self):
        assert not self.dirty
        self.current_indent = self.current_indent[:-2]

    def write(self, text):
        if not self.dirty:
            self.out.write(self.current_indent)
        self.out.write(text)
        self.dirty = True

    def end_of_line(self):
        self.out.write('\n')
        self.dirty = False

    def write_line(self, text):
        assert not self.dirty
        self.write(text)
        self.end_of_line()

    def get_output(self):
        return self.out.getvalue()

out = OutputWriter()

current_line_number = 0
current_section = ".text"
current_function_number = 0
data_labels = {}
import_funs = []

def error(message, line_number=None):
    if line_number is None:
        line_number = current_line_number
    sys.stderr.write('error at line ' + str(line_number) + ': ' +
                     message + '\n')
    sys.exit(1)

def resolve_label(arg):
    # Labels can be of the form 'foo' or 'foo+47'. Split the offset out so that
    # we can resolve the base symbol and then re-add the offset to the result
    # to produce a simple constant.
    #
    # If the symbol is undefined, we'll just emit it as '$foo+47', which isn't
    # currently valid syntax, but unresolved global variable addresses aren't
    # supported in wasm anyway, and if we do add support for them to wasm, we
    # should add support for offsets too :-).
    #
    # Test for '(' so that we avoid revisiting sexprified stacked operands.
    if (arg[0] != '('):
        parts = arg.split('+', 1)
        base = parts[0]
        offset = 0 if len(parts) == 1 else int(parts[1])
        if data_labels.has_key(base):
            return str(data_labels[base] + offset)
    if arg[0].isalpha() and arg != 'infinity' and arg != 'nan':
        return '$' + arg
    return arg

class PassHandler(object):
    def begin_pass(self):
        pass

    def end_pass(self):
        pass

    def handle_label(self, labelname):
        pass

    def handle_mnemonic(self, command, args):
        pass

    def handle_dot_globl(self, args):
        pass

    def handle_dot_param(self, args):
        pass

    def handle_dot_result(self, args):
        pass

    def handle_dot_local(self, args):
        pass

    def handle_dot_size(self, args):
        pass

    def handle_dot_int8(self, args):
        pass

    def handle_dot_int16(self, args):
        pass

    def handle_dot_int32(self, args):
        pass

    def handle_dot_int64(self, args):
        pass

    def handle_dot_zero(self, args):
        pass

    def handle_dot_ascii(self, rest, terminate):
        pass

    def handle_dot_align(self, args):
        if current_section == '.text':
            error("TODO: implement .align for functions")

    def handle_dot_lcomm(self, args):
        pass

    def handle_dot_import(self, args):
        pass

def reduce_to_bytes(x, num_bytes):
    data = []
    while num_bytes > 0:
        data.append(chr(x & 255))
        x >>= 8
        num_bytes -= 1
    assert x == 0 or x == -1
    return data

# TODO split data segment if there is enough space between non-zero bytes.
class DataSegment(object):
    def __init__(self):
        self.base = 0
        self.data = []
        self.trailing_zeros = 0

    def align_to(self, align):
        while self.end() % align != 0:
            self.trailing_zeros += 1

    def fixup(self, addr, value, num_bytes):
        pos = addr - self.base
        b = reduce_to_bytes(value, num_bytes)
        self.data[pos:pos + num_bytes] = b

    def append_byte(self, byte):
        if byte == '\0':
            # We want to trim trailing zeros from the end of the data segment,
            # so defer writing them until we encounter a non-zero byte.
            self.trailing_zeros += 1
        else:
            if self.data:
                # Flush the accumuated zeros before outputing this non-zero
                # byte.
                for i in range(self.trailing_zeros):
                    self.data.append('\0')
            else:
                # There is currently nothing in the data segment but zeros, so
                # shift the begining of the data segment to this non-zero byte.
                self.base += self.trailing_zeros
            self.trailing_zeros = 0
            self.data.append(byte)

    def append_integer(self, value, num_bytes):
        for b in reduce_to_bytes(value, num_bytes):
            self.append_byte(b)

    def append_zeros(self, num_bytes):
        self.trailing_zeros += num_bytes

    def end(self):
        return self.base + len(self.data) + self.trailing_zeros

class DataPassHandler(PassHandler):
    def __init__(self, segment):
        self.segment = segment
        self.reloc = []

    def end_pass(self):
        # Fix up relocations.
        for pos, num_bytes, symbol, line_number in self.reloc:
            if symbol in data_labels:
                self.segment.fixup(pos, data_labels[symbol], num_bytes)
            else:
                error("can't resolve symbol %r" % symbol, line_number)

    def align_data_to(self, align):
        self.segment.align_to(align)

    def handle_label(self, labelname):
        if current_section == ".data":
            data_labels[labelname] = self.segment.end()

    def handle_dot_intx(self, arg, num_bytes):
        try:
            x = int(arg)
        except ValueError:
            # It's a symbol, fix it up later.
            # We need to ensure that variables needing relocation are allocated
            # in the data segment. Any zero byte could be stripped out of the
            # data segment, so set all the bits of the variable, for now.
            x = 2**(num_bytes*8)-1
            self.reloc.append((self.segment.end(), num_bytes, arg, current_line_number))
        self.segment.append_integer(x, num_bytes)

    def handle_dot_int8(self, args):
        self.handle_dot_intx(args[0], 1)

    def handle_dot_int16(self, args):
        self.handle_dot_intx(args[0], 2)

    def handle_dot_int32(self, args):
        self.handle_dot_intx(args[0], 4)

    def handle_dot_int64(self, args):
        self.handle_dot_intx(args[0], 8)

    def handle_dot_zero(self, args):
        self.segment.append_zeros(int(args[0]))

    def handle_dot_ascii(self, rest, terminate):
        # Strip off the leading and trailing quotes.
        assert rest[0] == '"', rest
        assert rest[-1] == '"', rest
        s = rest[1:-1]
        i = 0

        escapes = {
            'n': '\n',
            'r': '\r',
            't': '\t',
            'f': '\f',
            'b': '\b',
            '\\': '\\',
            '\'': '\'',
            '"': '"',
        }
        while i < len(s):
            c = s[i]
            if c == '\\':
                i += 1
                c = s[i]
                if c in escapes:
                    self.segment.append_byte(escapes[c])
                    i += 1
                elif '0' <= c and c <= '7' and i + 2 < len(s):
                    data = s[i:i+3]
                    try:
                        self.segment.append_byte(chr(int(data, 8)))
                        i += 3
                    except ValueError:
                        error("bad octal escape - " + data)
                else:
                    error("unsupported escape - " + c)
            else:
                self.segment.append_byte(c)
                i += 1
        if terminate:
            self.segment.append_byte('\0')

    def handle_dot_align(self, args):
        self.align_data_to(1 << int(args[0]))

    def handle_dot_lcomm(self, args):
        name = args[0]
        size = int(args[1])
        align = (1 << int(args[2]))
        self.align_data_to(align)
        self.handle_label(name)
        self.segment.append_zeros(size)

sig_element_match = re.compile(r'(\((param|result) ([^\)]+)\))')

# For functions with more than one parameter, LLVM is currently generating:
# (param i32) (param i32) (result i32)
# when it should really be generating:
# (param i32 i32) (result i32)
# Do some string manipulation to fix this, but make sure we will accept the
# correct input, too.
def massage_import(text):
    params = []
    results = []
    for _, which, types in sig_element_match.findall(text):
        # Accumulate the types being declared.
        if which == "param":
            params.extend(types.split())
        elif which == "result":
            results.extend(types.split())
        else:
            raise NotImplementedError(which)
    # Remove the original param and result declarations.
    text = sig_element_match.sub("", text).strip()
    # Recreate the params.
    if params:
        text = "%s (param %s)" % (text, " ".join(params))
    # Recreate the results.
    if results:
        text = "%s (result %s)" % (text, " ".join(results))
    return text

class ImportsPassHandler(PassHandler):
    def __init__(self):
        self.imports = []

    def end_pass(self):
        for i in self.imports:
            # Split out the import symbol name, the module name, the function
            # name, and the rest is signature information.
            parts = i.split(None, 3)
            out.write_line('(import $' + parts[0] + ' ' + parts[1] +
                           ' "' + parts[2] + '" ' + ' '.join(parts[3:]) + ')')

    def handle_dot_import(self, args):
        i = massage_import(args[0])
        self.imports.append(i)
        import_funs.append(i[0:i.find(' ')])

# Convert an instruction from mnemonic syntax to sexpr syntax.
def sexprify(command, args):
    s = '(' + command
    if len(args) != 0:
        s += ' '
    s += ' '.join([resolve_label(arg) for arg in args if not arg.endswith('=')])
    s += ')'
    return s

class TextPassHandler(PassHandler):
    def __init__(self):
        self.expr_stack = []
        self.current_function = None
        self.current_label = None
        self.block_labels = {}

    def push_label(self, label):
        if label in self.block_labels:
            self.block_labels[label] += 1
        else:
            self.block_labels[label] = 1

    def end_pass(self):
        assert len(self.expr_stack) == 0, self.expr_stack
        assert self.current_function is None, self.current_function

    def handle_label(self, labelname):
        if current_section == ".text":
            if self.current_function is not None:
                # Label inside a function.
                if labelname.startswith('func_end'):
                    pass
                else:
                    if labelname in self.block_labels:
                        for i in range(0, self.block_labels[labelname]):
                            out.dedent()
                            out.write_line(')')
                    self.block_labels[labelname] = 0
                    self.current_label = labelname
            else:
                # Label for a function.
                assert self.current_function is None, self.current_function
                self.current_function = labelname
                out.write_line('(func $' + labelname)
                out.indent()

    def handle_mnemonic(self, command, args):
        # Handle address arguments of stores which have offsets.
        # Make the offset part of the command instead of an arg, otherwise
        # sexprify will interpret 'offset' as a label and prepend a '$'
        if 'load' in command or 'store' in command:
          m = re.match(r'(.+)\((.+)\)', args[1])
          if m:
            command += ' offset=' + m.group(1)
            args[1] = m.group(2)

        # Replace uses of $pop with expressions from the stack. We iterate
        # in reverse order since that's the order the pops are defined to
        # happen in in the assembly syntax.
        for i in range(len(args) - 1, -1, -1):
            if args[i].startswith('$pop'):
                args[i] = self.expr_stack.pop()
            elif args[i].startswith('$') and args[i][-1] != '=':
                # Strip the leading '$' and create a get_local.
                args[i] = '(get_local ' + args[i][1:] + ')'

        # Rewrite call to call_import.
        # TODO: Revisit this once
        # https://github.com/WebAssembly/design/issues/421
        # is resolved, and if we still have a call_import, decide if LLVM should
        # be emitting call_import itself.
        if command == 'call':
            for arg in args:
                if not arg.endswith('='):
                    if arg in import_funs:
                        command = 'call_import'
                        break

        if command == 'block':
            out.write_line('(block $' + args[0])
            self.push_label(args[0])
            out.indent()
            return
        if command == 'loop':
            out.write_line('(loop $' + args[0] + ' $' + self.current_label)
            assert len(self.expr_stack) == 0, self.expr_stack
            self.push_label(args[0])
            out.indent()
            return

        if command == 'copy_local':
            # This is a no-op which just produces a get_local and set_local.
            line = args[1]
        else:
            line = sexprify(command, args)

        if len([x for x in args if x.startswith('$push')]) != 0:
            self.expr_stack.append(line)
        elif len(args) > 0 and args[0].endswith('=') and args[0] != '$discard=':
            assert args[0][0] == '$', args[0]
            out.write_line('(set_local ' + args[0][1:-1] + ' ' + line + ')')
        else:
            out.write_line(line)

    def handle_dot_globl(self, args):
        # .globl statement could be declaring a name for either a global
        # variable or a function. We only want to export functions, so
        # filter out global variables.
        if args[0] not in data_labels:
            out.write_line('(export "' + args[0] + '" $' + args[0] + ')')

    def handle_dot_param(self, args):
        out.write_line(' '.join(['(param ' + x + ')' for x in args]))

    def handle_dot_result(self, args):
        out.write_line('(result ' + args[0] + ')')

    def handle_dot_local(self, args):
        out.write_line('(local ' + ' '.join(args) + ')')

    def handle_dot_size(self, args):
        global current_function_number

        if current_section == '.text':
            assert args[0] == self.current_function, args[0]
            # End of function body.
            out.dedent()
            out.write_line(')')
            self.current_function = None
            current_function_number += 1

def cleanup_line(line):
    # Traslate '# BB#0:' comments into proper BBx_0: labels. This hack is
    # needed because loops in LLVM output reference the block after the
    # loop, which LLVM doesn't emit a proper label for if it's only
    # reachable by fallthrough.
    if line.startswith('# BB#'):
        line = 'BB' + str(current_function_number) + '_' + line[5:]

    # Strip comments.
    i = 0
    while i < len(line):
        if line[i] == '"':
            # It's a string that may contain a hash character, so make sure we
            # don't confuse its contents with the start of a comment.
            i += 1
            while i < len(line):
                if line[i] == '"':
                    # End of string.
                    i += 1
                    break
                elif line[i] == '\\' and i + 1 < len(line) and line[i+1] == '"':
                    # Skip past escaped quotes.
                    i += 2
                else:
                    # String data.
                    i += 1
        elif line[i] == '#':
            # Strip the comment
            line = line[:i]
            break
        i += 1

    return line.strip()

def parse_line(line):
    # Split out the first part of the line, which determines what we do.
    parts = line.split(None, 1)
    command = parts[0]

    # The rest of the line is comma-separated args.
    if len(parts) > 1:
        rest = parts[1]
        args = [x.strip() for x in rest.split(',')]
    else:
        rest = ''
        args = []

    return command, args, rest

def handle_dot_directive(handler, command, args, rest):
    global current_section

    if command == 'text':
        current_section = ".text"
    elif command == 'data':
        current_section = ".data"
    elif command == 'imports':
      current_section = 'imports'
    elif command in ['file', 'type']:
        pass
    elif command == 'globl':
        handler.handle_dot_globl(args)
    elif command == 'param':
        handler.handle_dot_param(args)
    elif command == 'result':
        handler.handle_dot_result(args)
    elif command == 'local':
        handler.handle_dot_local(args)
    elif command == 'size':
        handler.handle_dot_size(args)
    elif command == 'int8':
        handler.handle_dot_int8(args)
    elif command == 'int16':
        handler.handle_dot_int16(args)
    elif command == 'int32':
        handler.handle_dot_int32(args)
    elif command == 'int64':
        handler.handle_dot_int64(args)
    elif command == 'zero':
        handler.handle_dot_zero(args)
    elif command == 'asciz':
        # Strings can contain embedded commas, so as a hack, pass the rest
        # of the line as a single argument.
        handler.handle_dot_ascii(rest, terminate=True)
    elif command == 'ascii':
        # Strings can contain embedded commas, so as a hack, pass the rest
        # of the line as a single argument.
        handler.handle_dot_ascii(rest, terminate=False)
    elif command == 'align':
        handler.handle_dot_align(args)
    elif command == 'lcomm':
        handler.handle_dot_lcomm(args)
    elif command == 'import':
        handler.handle_dot_import(args)
    else:
        error("unknown dot command: ." + command)

def do_pass(handler, all_lines):
    global current_line_number
    global current_section

    current_line_number = 0
    current_section = ".text"

    handler.begin_pass()

    for line in all_lines:
        current_line_number += 1 # First line is "1" in most editors.
        line = cleanup_line(line)
        if not line:
            continue
        command, args, rest = parse_line(line)

        # Decide what to do.
        if command.endswith(':'):
            if args:
                error("label with args")
            handler.handle_label(command[:-1])
        elif command.startswith('.'):
            handle_dot_directive(handler, command[1:], args, rest)
        else:
            handler.handle_mnemonic(command, args)

    handler.end_pass()

def write_data_segment(segment):
    mem_size = segment.end()
    out.write_line(('(memory ' + str(mem_size) + ' ' + str(mem_size)))
    out.indent()
    if segment.data:
        out.write_line('(segment %d' % segment.base)
        out.indent()
        out.write('"')
        for c in segment.data:
            if c == '\n':
                s = '\\n'
            elif c == '\t':
                s = '\\t'
            elif c == '\\':
                s = '\\\\'
            elif c == '\'':
                s = '\\\''
            elif c == '"':
                s = '\\"'
            elif ord(c) >= 32 and ord(c) < 127:
                # ASCII printable
                s = c
            else:
              s = '\\%02x' % ord(c)
            out.write(s)

        out.write('"')
        out.end_of_line()
        out.dedent()
        out.write_line(')')
    out.dedent()
    out.write_line(')')

def Main():
  cmd_args = ParseArgs()
  all_lines = readInput(cmd_args.input)

  out.write_line(
""";; This file was generated by wasmate.py, which is a script that converts
;; from the \"flat\" text assembly syntax emitted by LLVM into the s-expression
;; syntax expected by the spec repository.
;;
;; Note: this is a hack. A real toolchain will eventually be needed.
;;
""")

  # Open a module.
  out.write_line('(module')
  out.indent()

  segment = DataSegment()

  # Make three passes over the code: once to read all the data directives, once
  # to process all the text, and once for all the imports. This lets us resolve
  # all the data symbols so we can plug in absolute offsets into the text, while
  # having all the imports on top (which then lets us transform call to
  # call_import).
  do_pass(DataPassHandler(segment), all_lines)
  do_pass(ImportsPassHandler(), all_lines)
  do_pass(TextPassHandler(), all_lines)

  write_data_segment(segment)

  # Close the module.
  out.dedent()
  out.write_line(')')

  # Check invariants.
  assert len(out.current_indent) == 0, len(out.current_indent)

  text = out.get_output()

  if cmd_args.output == None:
    sys.stdout.write(text)
  else:
    with open(cmd_args.output, 'w') as outfile:
      outfile.write(text)


if __name__ == '__main__':
  sys.exit(Main())
