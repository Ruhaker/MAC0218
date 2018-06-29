require 'rubygems'
require 'nokogiri'
require 'open-uri'

if ARGV.count == 0
    puts "Usage: rails runner fetch_subject.rb <sgldis>"
    exit
end

page = Nokogiri::HTML(open("https://uspdigital.usp.br/jupiterweb/obterDisciplina?sgldis=#{ARGV[0]}&verdis=1&print=true"))   

def parse_data(page)
    a = page.xpath('//*/table/tr/td/b/font/span')
    puts "Faculdade: #{a[0].text.strip}"
    puts "Curso:     #{a[1].text.strip}"

    b = page.xpath('//*/table/tr/td/font/span/b')
    puts "Discplina: #{b[0].text.strip.match(/Disciplina: [^ ]+ - (.+)/i).captures.first}"

    c = page.xpath('//*/table/tr/td/font/span')
    puts "Crd. aula: #{c[3].text.strip.to_i}"
    puts "Crd. trab: #{c[4].text.strip.to_i}"
    puts "Carga hor: #{c[5].text.strip.to_i}"

    d = page.css('table>tr>td>font>span.txt_arial_8pt_gray')
    puts "Resumo   : #{d[5].text.strip}"

    ret = {}
    #ret[:faculdade    ] = a[0].text.strip
    #ret[:curso        ] = a[1].text.strip
    ret[:code         ] = b[0].text.strip.match(/Disciplina: ([^ ]+) - .+/i).captures.first
    ret[:name         ] = b[0].text.strip.match(/Disciplina: [^ ]+ - (.+)/i).captures.first
    ret[:credits_class] = c[3].text.strip.to_i
    ret[:credits_work ] = c[4].text.strip.to_i
    ret[:workload     ] = c[5].text.strip.to_i
    ret[:description  ] = d[5].text.strip

    return ret
end

data = parse_data(page)

printf "Add to database? [Y/N] "
confirm = STDIN.gets.chomp
exit unless confirm.downcase == 'y'
puts "Adding to database..."

begin
    if Subject.find_by({:code => data[:code]})
        raise "Alerady exists!"
    end

    Subject.create(data)
rescue Exception => e
    puts "Error: #{e}"
end