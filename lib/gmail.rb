require "gmail/version"

module Gmail

require 'net/smtp'
require "nkf"

  class GMail
    attr_accessor :subject, :body, :from_addr, :to_addrs
    def initialize(user_name, password)
      @server={
        :server =>  'smtp.gmail.com',
        :port   =>  587,
        :user   => user_name,
        :pass   => password,
      }
    end

    def deliver
      smtp = Net::SMTP.new(@server[:server], @server[:port])
      smtp.enable_starttls
      smtp.start('localhost.localdomain', @server[:user], @server[:pass], :plain) do |conn|
        conn.send_mail(create_body , @from_addr, *@to_addrs)
      end
    end

  private
    def create_body
msg= <<END_MAIL
Date: #{Time::now.strftime("%a, %d %b %Y %X")}
From: #{@from_addr}
To: #{@to_addrs.join(",")}
Subject: #{@subject}
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8

#{@body}
END_MAIL
    return msg
    end

  end
end
