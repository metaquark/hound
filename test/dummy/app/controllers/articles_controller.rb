class ArticlesController < ApplicationController

  def create
    @article = Article.create(article_params)
    head :ok
  end

  def update
    @article = Article.find(params[:id])
    @article.update_attributes(article_params)
    hound_action @article, 'something_custom'
    head :ok
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    head :ok
  end

  private
  def article_params
    params.require(:article).permit :body, :title
  end
end
