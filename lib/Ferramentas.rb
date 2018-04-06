#!usr/bin/ruby
require 'rubygems'
require 'mechanize'
require 'json'

class Ferramentas

 # faço a primeira conecção depois o login
  def connectSite(url = "")

    agent = Mechanize.new
    agent = Mechanize.new {|agent| agent.ssl_version, agent.verify_mode = 'TLSv1',OpenSSL::SSL::VERIFY_NONE}
    agent.request_headers = {'User-agent'=>'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008071615 Fedora/3.0.1-1.fc9 Firefox/3.0.1'}
    page = agent.get(url)
    @obj_page = page.forms.first
    @title_page = page.title

    if __checkTitle('Login')
      @obj_page.field_with(:name=>"user").value = @usuario
      @obj_page.field_with(:name=>"pass").value = @senha
      __doPostBack()

      #caso tenha acessado a pagina localizo se o login foi bem suceddido
      error = @obj_page.search(".type-error").text

      if error.length != 0
        @error.push("login_access::Erro do login: #{error}")
      end

    else
      @error.push("pg_login::A página de login não foi encontrada ou mudaram o título do navegador para outro outro diferente de Login")
    end

  end # fim do connectMary

  def acessarLink(url)
    @obj_page = @obj_page.links_with(:href => url)[0].click()
    @title_page = @obj_page.title
  end

 #gera um arquivo de visualizacao na pasta principal (atualmente)
  def generateView(name, body , ext = 'html')
    somefile = File.open("#{name}.html", "w")
      somefile.puts body
    somefile.close
  end

  def __checkTitle(cktitle)
    if @title_page.include?(cktitle)
      return true
    else
      return  false
    end
  end


end # fim da class
