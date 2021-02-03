class MessagesController < ApplicationController
  before_action(:log_in_user)
  before_action(:find_messageable)
  before_action(:set_message, only: [:destroy])
  before_action(:correct_user, only: [:destroy])
  before_action(:create_correct_user, only: [:create])

  def create
    @message = @messageable.messages.new(user: current_user, content: params[:message][:content])
    if @message.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to(@messageable)
    else
      flash[:danger] = 'メッセージは200文字以内で投稿して下さい。'
      redirect_to(@messageable)
    end
  end

  def destroy
    @message.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_to(@messageable)
  end

  private
    def find_messageable
      @klass = Class.const_get(params[:messageable_type])
      @messageable = @klass.find(params[:messageable_id])
    end

    def set_message
      @message = Message.find(params[:id])
    end

    def correct_user
      unless @message.user == current_user
        flash[:danger] = '正しいユーザーではありません。'
        redirect_to(@messageable)
      end
    end

    def create_correct_user
      if !@messageable.can_send_message?(current_user)
        flash[:danger] = '有効なユーザーではないか、すでに取引済みです。'
        redirect_to(root_url)
      end
    end
end
