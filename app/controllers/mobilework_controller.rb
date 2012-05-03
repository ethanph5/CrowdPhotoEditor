require "net/http"
require "net/https"
require "rubygems"
require "json"

class MobileworkController < ApplicationController
  def submit_task
    counter = 0
    
    
    picIDlist = session[:picture].keys if session[:picture]
    picfblist = session[:picturefb].keys if session[:picturefb]
    taskTable = session[:tasks] if session[:tasks]
    resultTable = session[:results] if session[:results]
    #debugger
    #if params[:picTable] != nil
      #picTable = params[:picTable] #picTable: key is pic id(string), value is 1
      #picIDlist = picTable.keys #unfortunately, ids are string, not integer
    #end

    #if params[:picfbTable] != nil    
      #picfbTable = params[:picfbTable]
      #picfblist = picfbTable.keys
    #end
    
    #taskTable = params[:taskTable] #key is picture id, value is the task string
    #resultTable = params[:resultTable] #key is picture id, value is the # of result the user wants
    #debugger
    submission_notice = []
    submission_error = []
    
    
    #if params[:picTable] != nil
    if not picIDlist.empty?
      picIDlist.each { |id|
        intID = id.to_i
        task = taskTable[id]
        numResult = resultTable[id]
        internal_link = Picture.find(intID).internal_link #resource location
        question = "<h3>Tasks:</h3><blockquote>"+
task+"</blockquote> <h3>Resource:</h3><blockquote>"+"<a href="+internal_link+">"+internal_link+"</a></blockquote>
<h3>Instruction:</h3><blockquote><li>Save the picture in given link to your computer</li><li>Use http://pixlr.com/editor/ or another photo-editor of your choice</li><li>Perform specified tasks, make sure you do everything specified!</li><li>(If instructions are overly vague, simply decline the task)</li><li>Upload the photo to http://imm.io and return the link to your picture in the Answer Box</li><li>We only accept JPG files!</li></blockquote>" 
        #question = task + " I want " + numResult + " different versions. Thank you!"
        
        success_check = 1
        1.upto(numResult.to_i) {
          url = URI("https://sandbox.mobileworks.com/api/v1/tasks/")
          http = Net::HTTP.new(url.host, 443)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          http.start {|http|
            headers = {"Content-Type" => "application/json"}
            req = Net::HTTP::Post.new(url.path, headers)
            req.basic_auth('ethanph5','dxlf1314')
            query = {
              "question" => question,
              #"resource" => internal_link, #maybe discard this resource
              "answerType" => "t"
            }
            req.body = query.to_json()
            response = http.request(req)

            if response.code == "201"
              #submission_notice << "The task for #{Picture.find(intID).name} has been submitted successfully." 
              #session.delete(:picture) #clear session[picture] here
              newResponse = response["location"] + "?format=json/"
              #puts response["location"] #response["location"] is http://sandbox.mobileworks.com/api/v1/tasks/229/
              Query.create!(:user_id => current_user.id, :task_link => newResponse, :result_link => "", :task => task)
            
            else
              success_check = 0 #something wrong happened!
              #submission_error << "Sorry! The task for #{Picture.find(intID).name} has NOT been submitted successfully. Please try again!"   
              #puts "Error. Response code: " + response.code
            end
          }
        }
      
        if success_check == 1 #nothing has ever gone wrong
          submission_notice << "The task(s) for #{Picture.find(intID).name} has been submitted successfully."
          session.delete(:picture) #clear session[picture] here
        else
          submission_error << "Sorry! The task(s) for #{Picture.find(intID).name} has NOT been submitted successfully. Please try again!"  
        end
      }
    end
    
    
    #-------------------------------------- facebook part ----------------------------
    if not picfblist.empty?
      fb_user = current_user.fb_user     
      picfblist.each { |id|
        counter = counter + 1
        task = taskTable[id]
        numResult = resultTable[id]
        internal_link = fb_picture_link(fb_user, id) 
        #debugger
        #internal_link = id #resource location
        question = "<h3>Tasks:</h3><blockquote>"+
task+"</blockquote> <h3>Resource:</h3><blockquote>"+"<a href="+internal_link+">"+internal_link+"</a></blockquote>
<h3>Instruction:</h3><blockquote><li>Save the picture in given link to your computer</li><li>Use http://pixlr.com/editor/ or another photo-editor of your choice</li><li>Perform specified tasks, make sure you do everything specified!</li><li>(If instructions are overly vague, simply decline the task)</li><li>Upload the photo to http://imm.io and return the link to your picture in the Answer Box</li><li>We only accept JPG files!</li></blockquote>"
        
        
        success_check = 1
        1.upto(numResult.to_i) {          
          url = URI("https://sandbox.mobileworks.com/api/v1/tasks/")
          http = Net::HTTP.new(url.host, 443)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          http.start {|http|
            headers = {"Content-Type" => "application/json"}
            req = Net::HTTP::Post.new(url.path, headers)
            req.basic_auth('ethanph5','dxlf1314')
            query = {
              "question" => question,
              #"resource" => internal_link,
              "answerType" => "t"
            }
            req.body = query.to_json()
            response = http.request(req)    
            
            if response.code == "201"
              #submission_notice << "The task for #{Picture.find(intID).name} has been submitted successfully." 
              #session.delete(:picture) #clear session[picture] here
              newResponse = response["location"] + "?format=json/"
              #puts response["location"] #response["location"] is http://sandbox.mobileworks.com/api/v1/tasks/229/
              Query.create!(:user_id => current_user.id, :task_link => newResponse, :result_link => "", :task => task)
            
            else
              success_check = 0 #something wrong happened!
              #submission_error << "Sorry! The task for #{Picture.find(intID).name} has NOT been submitted successfully. Please try again!"   
              #puts "Error. Response code: " + response.code
            end
          }
        }
        
        if success_check == 1 #nothing has ever gone wrong
            submission_notice << "The task for photo Facebook #{counter} has been submitted successfully." 
            session.delete(:picturefb) #clear session[picture] here
        else
          submission_error << "Sorry! The task for photo Facebook #{counter} has NOT been submitted successfully. Please try again!"  
        end
      }
    end
    
    #end of facebook part
    
    redirect_to :controller => :dashboard, :action => :index, :submission_notice => submission_notice, :submission_error => submission_error and return
  end  
  
  def fb_picture_link(fb_user, picture_id)
    albums = fb_user.albums
    albums.each do |album|
      album.photos.each do |photo|
        #debugger     
        if photo.identifier == picture_id
          return photo.source
        end
      end
    end
  end
  
end
