# The mailer for the newsletter
#
class Newslettermail < ActionMailer::Base
  default from: "no-reply@soonzik.com"
  layout 'mailer'

  def newsletter_email(email, subject, content)
    @content  = content
    @subject  = subject
    mail(to: email, subject: @subject)
  end
end
