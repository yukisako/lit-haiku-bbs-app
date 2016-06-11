require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'sinatra/json'
require './models/contribution.rb'
require './image_uploader.rb'

def num_to_k(n)
  number = 0..9
  kanji = ["","一","二","三","四","五","六","七","八","九"]
  num_kanji = Hash[number.zip(kanji)]
  digit = [1000,100,10]
  # digit = (1..3).map{ |i| 10 ** i }.reverse
  kanji_keta = ["千","百","十"]
  num_kanji_keta = Hash[digit.zip(kanji_keta)]
  num = n
  str = ""
  digit.each { |d|
    tmp = num / d
    str << (tmp == 0 ? "" : ((tmp == 1 ? "" : num_kanji[tmp]) + num_kanji_keta[d]))
    num %= d
  }
  str << num_kanji[num]
  return str
end


get '/' do
  @contents = Contribution.order('id desc').all
  erb :index
end

post '/new' do
  Contribution.create({
    author: params[:author],
    haiku1: params[:haiku1],
    haiku2: params[:haiku2],
    haiku3: params[:haiku3],
    haiku4: params[:haiku4],
    haiku5: params[:haiku5],
    img: "",
    good: 0
    })

  if params[:file]
    image_upload(params[:file])
  end

  redirect '/'
end

post '/good/:id' do
  @content = Contribution.find(params[:id])
  good = @content.good
  @content.update({
    good: good + 1
  })
  redirect '/'
end

post '/delete/:id' do
  Contribution.find(params[:id]).destroy
  redirect '/'
end

post '/edit/:id' do
  @content = Contribution.find(params[:id])
  erb :edit
end

post '/renew/:id' do
  @content = Contribution.find(params[:id])
  @content.update({
    author: params[:author],
    haiku1: params[:haiku1],
    haiku2: params[:haiku2],
    haiku3: params[:haiku3],
    haiku4: params[:haiku4],
    haiku5: params[:haiku5],
    })
  redirect '/'
end