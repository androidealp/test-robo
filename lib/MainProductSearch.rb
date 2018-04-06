#!usr/bin/ruby
require 'mechanize'
require 'nokogiri'
require_relative 'Ferramentas'

#
#### Efetua a buscas no catalogo de produtos do site com autneticacao
#
class ProductSearch < Ferramentas
 attr_accessor :usuario, :senha, :error, :prod_type, :url_type, :obj_page, :title_page, :produtos_links, :list_checked
 def initialize(usuario="", senha="", url = "" )
   @error =[]

   if url.length == 0
     url = 'https://www.meusite.com.br'
   end

   # verifico se o usuario foi informado corretamente se false insere no @error
   @usuario =  checkVal(usuario)
   # verifico se a senha foi informada corretamente se false insere no @error
   @senha = checkVal(senha)

   if @error.length == 0
     connectSite(url)
     acessarLink(url+'/minha-lista-produtos')
   end

 end # fim initialize


 def generateXml
   produtos = getProdutosHash()

   builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|

      xml.root {
        xml.produtos_relatorio {
          produtos.each do |produto|
            xml.total menu[:total]
            menu[:produtos].each do |item|
              xml.item('nome'=>item[:titulo], 'conteudo'=>item[:conteudo]) {
              
              }
            end 
          end 
        }
      }
    end # fim do builder
   return  builder.to_xml
 end

 # return [] produtos hash total
 def getProdutosHash()

   listaprodutos = []

   @obj_page.search(".box-categorias a").each do |link|
     gettext = link.text.strip.downcase
     getlink = link['href']
    # pego os itens
       listaprodutos << getproductofCategory(getlink)
   end #fim do search

   return  listaprodutos

 end # fim do metodo

# return :total e :produtos
 def getproductofCategory(link)
     accesspag = @obj_page.links_with(:href => link)[0].click()
     contadoritens = 0
   categorias = Array.new()
  if accesspag.at_css('.itens')
     accesspag.search('.itens').each do |content|
         
       titulo = content.at(".title").text.strip.downcase
       produtos ={:conteudo=>content.at(".content").text.strip.downcase,:titulo=>titulo}
        
       contadoritens += 1
     end # fim do search

   return {:total=>contadoritens, :produtos=>produtos}
 end

def exibirResultados
  return @produtos_links
end



end # fim class main
