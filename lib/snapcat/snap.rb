module Snapcat
  class Snap
    ALLOWED_FIELD_CONVERSIONS = {
      broadcast: :broadcast,
      broadcast_action_text: :broadcast_action_text,
      broadcast_hide_timer: :broadcast_hide_timer,
      broadcast_url: :broadcast_url,
      c: :screenshot_count,
      c_id: :media_id,
      id: :id,
      m: :media_type,
      rp: :recipient,
      sn: :sender,
      st: :status,
      sts: :sent,
      ts: :opened,
      t: :duration
    }

    attr_reader *ALLOWED_FIELD_CONVERSIONS.values

    def initialize(data = {})
      humanize_data(data)
      @status = Status.new(@status)
      @media_type = Media::Type.new(code: @media_type)
    end

    def received?
      !sent?
    end

    def sent?
      !!media_id
    end

    private

    def humanize_data(data)
      ALLOWED_FIELD_CONVERSIONS.each do |api_field, human_field|
        instance_variable_set(
          "@#{human_field}",
          data[human_field] || data[api_field]
        )
      end
    end

    class Status
      NONE = -1
      SENT = 0
      DELIVERED = 1
      OPENED = 2
      SCREENSHOT = 3

      attr_reader :code

      def initialize(code)
        @code = code
      end

      def delivered?
        @code == DELIVERED
      end

      def opened?
        @code == OPENED
      end

      def sent?
        @code == SENT
      end

      def screenshot?
        @code == SCREENSHOT
      end

      def none?
        @code == NONE
      end
    end
  end
end
