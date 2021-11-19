class UsersController < ApplicationController
  def index
  end

  def new
  end

  def edit
  end

  def show
    @user = User.new(
      name: "Vadim",
      username: "installero",
      avatar_url: "https://secure.gravatar.com/avatar/" \
      "71269686e0f757ddb4f73614f43ae445?s=100"
    )
    @questions = [
      Question.new(text: 'Как дела?', created_at: Date.parse('27.03.2016'))
    ]
  end
end
