class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
  end

  def edit
  end

  def show
    @user = User.find params[:id]

    @questions = @user.questions
    @questions_amount = @questions.size
    @answers_amount = @questions.size(&:answer)
    @unanswered_amount = @questions_amount - @answers_amount

    @new_question = Question.new
  end
end
