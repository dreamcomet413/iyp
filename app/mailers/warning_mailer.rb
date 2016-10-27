class WarningMailer < ActionMailer::Base
  default from: "wapi-dhone@wapiapp.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.warning_mailer.heavy_server_load.subject
  #
  def heavy_server_load
    @admin_email = "webmaster@paypercall.org"
    @message     = "num_matches overload"

    mail to: @admin_email
  end
end
