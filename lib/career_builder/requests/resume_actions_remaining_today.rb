module CareerBuilder

  module Requests

    class ResumeActionsRemainingToday < Request::Authenticated

      VALID_OPTIONS = [:account_did]

      def perform
        super
        response = perform_request("V2_ResumeActionsRemainingToday", transform_options_to_xml(options))

        xml_from_response = parse_terrible_response(response)
        doc = Nokogiri::XML(xml_from_response)
        doc.xpath("//Packet").text.to_i
      end

    end

  end

end
