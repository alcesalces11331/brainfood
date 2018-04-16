require 'sinatra/base'
class BooksController < ApplicationController

  get '/books' do
    (logged_in?) ? (erb :'books/books') : (redirect to '/login')
  end

  #CRUD

  #----------------------------------- Create New Books -------------------------------
  
  get '/books/new' do
    @user = current_user
    erb :'/books/new' 
  end 

  post '/books' do
    @user = current_user
    if !!params[:book][:shelf_id] && valid?(params[:shelf])
      flash[:message] = "Please Choose or Create ONE Shelf for this Book."
      erb :'/books/new'

    elsif valid?(params[:book])
      @book = Book.create(params[:book])
      redirect to "/books/#{@book.id}"

    else valid?(params[:shelf])
      @book = Book.new(params[:book])
      @book.shelf = Shelf.create(params[:shelf])
      @book.save
      redirect to "/books/#{@book.id}"
    end 
  end

  #------------------------------------- Show Books -----------------------------------

  get '/books/:id' do
    login_checkpoint
    @book = Book.find_by_id(params[:id])
    erb :'/books/show_book'
  end

  #------------------------------------- Edit Books -----------------------------------

  get '/books/:id/edit' do
    login_checkpoint
    @book = Book.find_by(id: params[:id])
    erb :'/books/edit'
  end 

  patch '/books/:id' do
    book = Book.find_by(id: params[:id])
    book.update(params[:book])
    redirect to "/books/#{book.id}"
  end

    #--------------------------------- Delete Books ---------------------------------

  delete '/books/:id/delete' do 
    book = Book.find_by(id: params[:id])
    flash[:notice] = "#{book.title} has been deleted."
    book.destroy
    @user = current_user
    erb :'/users/show'
  end 
  
end 