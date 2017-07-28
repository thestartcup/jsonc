###
# Copyright (c) 2017 The Start Cup, LLC. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
###

readInt = (bytes, i) ->
  bytes[i] | bytes[i+1] << 8 | bytes[i+2] << 16 | bytes[i+3] << 24


parse = (bytes, classname, classdefs) ->
  parseElement = (i, type) ->
    switch type
      when 'int' then [readInt(bytes, i), i + 4]
      when 'double' then [readDouble(bytes, i), i + 8]
      when 'string' then readString(bytes, i)
      else parseClass(i, classdefs[type])

  parseArray = (i, elemtype, length) ->
    [(for j in [0..length]
      [element, i] = parseElement(i, elemtype)
      element), i]

  parseClass = (i, thisclass) ->
    for key, type in thisclass
      [type, arraylen] = type.match(/(.*)\[([0-9]*)\]/) ? [type, '']
      if arraylen is ''
        [out[key], i] = parseElement(i, type)
      else
        [out[key], i] = parseArray(i, type, Number(arraylen))

  out = {}
  parseClass(0, classdefs[classname])[0]
