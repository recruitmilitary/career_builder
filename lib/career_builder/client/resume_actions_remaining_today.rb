module CareerBuilder
  class Client
    module ResumeActionsRemainingToday

      VALID_OPTIONS = [:account_did]

      def resume_actions_remaining_today(options = {})
        response = auth_request("V2_ResumeActionsRemainingToday", options)

        doc = Nokogiri::XML(response)
        doc.xpath("//Packet").text.to_i
      end

    end
  end
end
