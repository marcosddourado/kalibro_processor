module CompoundResults
  class JavascriptEvaluator

    def initialize
      #V8 is a JavaScript interpreter
      @script = V8::Context.new #FIXME: set a timeout to avoid infinite loops and cyclic dependencies
    end

    def add_variable(identifier, value)
      validate_identifier(identifier)
      @script[identifier] = value
    end

    def add_function(identifier, body)
      validate_identifier(identifier)
      @script.eval("#{identifier} = function (){ #{body} }")
    end

    def evaluate(identifier)
      @script.eval("#{identifier}()")
    end

    private

    def validate_identifier(identifier)
      raise Errors::InvalidIdentifierError.new("Invalid identifier: #{identifier}") if (identifier =~ /^[a-zA-Z_$][a-zA-Z0-9_$]*$/).nil?
    end
  end
end