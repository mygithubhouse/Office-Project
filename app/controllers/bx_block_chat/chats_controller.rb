module BxBlockChat
  class ChatsController < ApplicationController
    before_action :find_chat, only: [:read_messages]

    def index
      chats = current_user.chats
      render json: ::BxBlockChat::ChatOnlySerializer.new(chats, serialization_options).serializable_hash, status: :ok
    end

    def show
      chat = BxBlockChat::Chat.includes(:accounts).find(params[:id])
      render json: ::BxBlockChat::ChatSerializer.new(chat, serialization_options).serializable_hash, status: :ok
    end

    def create
      chat = BxBlockChat::Chat.new(chat_params)
      chat.chat_type = "multiple_user"
      if chat.save
        BxBlockChat::AccountsChatsBlock.create(account_id: current_user.id,
          chat_id: chat.id,
          status: :admin)
        render json: ::BxBlockChat::ChatSerializer.new(chat, serialization_options).serializable_hash, status: :created
      else
        render json: {errors: chat.errors}, status: :unprocessable_entity
      end
    end

    def history
      chat_ids = AccountBlock::Account.find(params[:receiver_id]).chats.pluck(:id)
      chats = current_user.chats.where(id: chat_ids)
      if chats.present?
        render json: ::BxBlockChat::ChatHistorySerializer.new(chats, chat_message_serialization_options).serializable_hash, status: :ok
      else
        render json: {message: "They don't have any chat history"}
      end
    end

    def read_messages
      @chat.messages&.all&.update(is_mark_read: true)
      render json: ::BxBlockChat::ChatSerializer.new(@chat, serialization_options).serializable_hash, status: :ok
    rescue => e
      render json: {error: e}
    end

    def update
      chat = Chat.find(params[:id])
      if !params[:chat][:name].nil?
        Chat.where(id: chat.id).update(name:params[:chat][:name])
      end
      if !params[:chat][:muted].nil?
        current_user.accounts_chats.where(chat_id: chat.id).first.update(muted: params[:chat][:muted])
      end
      chat.reload
      if chat.present?
        render json: ::BxBlockChat::ChatSerializer.new(
          chat, serialization_options
        ).serializable_hash, status: :ok
      else
        render json: {errors: format_activerecord_errors(chat.errors)},
          status: :unprocessable_entity
      end
    end

    def search
      @chats = current_user
        .chats
        .where("name ILIKE :search", search: "%#{search_params[:query]}%")
      render json: ChatSerializer.new(@chats, serialization_options).serializable_hash, status: :ok
    end

    def search_messages
      @messages = ChatMessage
        .where(chat_id: current_user.chat_ids)
        .where("message ILIKE :search", search: "%#{search_params[:query]}%")
      render json: ChatMessageSerializer.new(@messages, serialization_options).serializable_hash, status: :ok
    end

    private

    def chat_params
      params.require(:chat).permit(:name)
    end

    def search_params
      params.permit(:query)
    end

    def find_chat
      @chat = Chat.find_by_id(params[:chat_id])
      render json: {message: "Chat room is not valid or no longer exists"} unless @chat
    end
  end
end
