# frozen_string_literal: true
module BxBlockCategories
  class QuestionsController < ApplicationController
    before_action :validate_json_web_token, only: [:show, :index, :update]
    
    def index
      questions = BxBlockCategories::Question.Yes.where(question_type: "Profile")
      render json: QuestionsSerializer.new(questions, params: { question: questions }).serializable_hash
    end

    def show
      @question = Question.find(params[:id])
      render json: QuestionsSerializer.new(@question, params: { question: @question }).serializable_hash
    end

    def create
      @question = Question.new(question_params)
      if @question.save
        render json: QuestionsSerializer.new(@question, params: { question: @question }).serializable_hash
      else
        render json: { errors: "Question can't be saved", errors: @question.errors }, status: 400
      end
    end

    def update
      @question = Question.find(params[:id])
      if @question.update(question_params)
        render json: QuestionsSerializer.new(@question, params: { question: @question }).serializable_hash
      else
        render json: { message: "Question can't be updated", errors: question.errors }, status: 400
      end
    end

    def destroy
      question = Question.find(params[:id])
      question.destroy
      render json: { message: 'Question deleted!' }
    end

    def question_params
      params.require(:question).permit(:content, :question_type, options: [])
    end
  end
end
