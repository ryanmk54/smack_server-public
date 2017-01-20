module ProjectFeatureExtractor
  class MethodProperties
    def initialize(raw_code)
	  @raw_code = raw_code
	  @arguments = count_arguments
	  @child_methods
    end

    private

    def identify_arguments
    end

    def identify_child_methods
    end
  end

  class AssertionMethodProperties < MethodProperties

    def initialize(raw_code)
  	  super(raw_code)
  	  @assertions = identify_assertions
    end

    private 

    def identify_assertions
    end
  end
end
