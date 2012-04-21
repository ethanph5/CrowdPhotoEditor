require "net/http"
require "net/https"
require "rubygems"
require "json"

class MobileworkController < ApplicationController
  def submit_task
    picTable = params[:picTable] #picTable: key is pic id(string), value is 1
    picIDlist = picTable.keys #unfortunately, ids are string, not integer
    
    taskTable = params[:taskTable] #key is picture id, value is the task string
    resultTable = params[:resultTable] #key is picture id, value is the # of result the user wants
    
    picIDlist.each do |id|
      intID = id.to_i
      task = taskTable[id]
      numResult = resultTable[id] 
      question = task + " I want " + numResult + " different versions. Thank you!"
         
      internal_link = Picture.find(intID).internal_link #resource location
    
    
      url = URI("https://sandbox.mobileworks.com/api/v1/tasks/")
      http = Net::HTTP.new(url.host, 443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.start {|http|
        headers = {"Content-Type" => "application/json"}
        req = Net::HTTP::Post.new(url.path, headers)
        req.basic_auth('FelixXie','Phoenix1218118')
        query = {
          #"workflow" => "s"
          "question" => question,
          "resource" => internal_link,
          "answerType" => "t"
          #"redundancyType" => "p"
        }
        req.body = query.to_json()
        response = http.request(req)
    
        if response.code == "201"
            puts response["location"] #response["location"] is http://sandbox.mobileworks.com/api/v1/tasks/229/
        else
            puts "Error. Response code: " + response.code
        end
      }
    end
    redirect_to :controller => :dashboard, :action => :index and return
  end  
end