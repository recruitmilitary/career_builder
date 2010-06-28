module CareerBuilder

  class Resume < BasicObject

    attr_reader :client

    def initialize(client, partial_resume)
      @partial_resume = partial_resume
      @client = client
    end

    def real_contact_email
      full_resume.contact_email
    end

    private

    def method_missing(meth, *args, &block)
      if partial_resume.respond_to?(meth)
        partial_resume.send(meth, *args, &block)
      else
        if full_resume.respond_to?(meth)
          full_resume.send(meth, *args, &block)
        else
          super
        end
      end
    end

    def partial_resume
      @partial_resume
    end

    def full_resume
      @full_resume ||= client.get_resume(:resume_id => @partial_resume.id)
    end

  end

end
