
require_relative 'lib/ProductSearch'


# pego os parametros vindos do php caso a consulta não seja via cli
usuario = ARGV[0].to_s
senha =  ARGV[1].to_s
url = ARGV[2].to_s # url no sistema



object_search = ProductSearch.new(usuario,senha,url)




if object_search.error.length == 0

xml =  object_search.generateXml
datetime = Time.now.strftime("%Y-%m-%d-%H-%M-%s")

currenturl = File.dirname(__FILE__)
 filename = datetime+'-arquivo-analise.xml'
  arquivoxml = File.open(currenturl+'/'+filename, "w")
  arquivoxml.puts xml
  arquivoxml.close

  print filename
else
  print object_search.error
end
