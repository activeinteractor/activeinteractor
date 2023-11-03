# frozen_string_literal: true

require 'active_model'
require 'active_support'
require 'active_support/core_ext'

require_relative 'active_interactor/errors'

# ## License
#
# Copyright (c) 2023 Aaron Allen
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# {https://activeinteractor.org ActiveInteractor} is An implementation of the Command
# Pattern for Ruby with ActiveModel::Validations inspired by the interactor gem.
# It has features like rich support for attributes, callbacks, and validations, and
# thread safe performance methods.
#
# {file:CHANGELOG.md Changelog}
#
# {file:HUMANS.md Acknowledgements}
#
# {file:SECURITY.md Security Policy}
#
# @author {hello@aaronmallen.me Aaron Allen}

module ActiveInteractor
  extend ActiveSupport::Autoload

  autoload :ActiveModelErrorMethods
  autoload :Context
  autoload :Interactor
  autoload :Result
  autoload :Type
end
