class Email

  attr_accessor :to, :subject, :html_body

  def send(to = self.to, subject = self.subject, html_body = self.html_body)
    mail = Mail.new do
      to to
      from 'svc_wmsapp@tieto.com'
      subject subject

      text_part do
        content_type 'text/plain; charset=utf-8'
        body ''
      end

      html_part do
        content_type 'text/html; charset=utf-8'
        body html_body
      end
    end
    begin
      mail.deliver
      $logger.info("Email has been successfully sent to #{@to}.")
    rescue => error
      $logger.error(error)
      $logger.error("Email has not been sent! Receivers: #{@to}.")
    end
  end
end