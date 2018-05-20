class BlogsController < ApplicationController
  before_action :authenticate_user!
 before_action :set_blog, only: [:show, :edit, :update, :destroy]

  def index

    @blogs = Blog.all
   respond_to do |format|
    format.html
    format.js
   end
  end

  # showアククションを定義します。入力フォームと一覧を表示するためインスタンスを2つ生成します。
  def show
    @comment = @blog.comments.build
    @comments = @blog.comments
    Notification.find(params[:notification_id]).update(read: true) if params[:notification_id]
  end


  def new
    if params[:back]
      @blog = Blog.new(blogs_params)
    else
      @blog = Blog.new
    end
  end

 def create
    @blog = Blog.new(blogs_params)
    @blog.user_id = current_user.id
    if @blog.save
      # 一覧画面へ遷移して"ブログを作成しました！"とメッセージを表示します。
      redirect_to blogs_path, notice: "ブログを作成しました！"
    # 一時的にコメントアウト　 NoticeMailer.sendmail_blog(@blog).deliver
    else
      # 入力フォームを再描画します。
      render 'new'
    end
 end


     def edit
      if @blog.user_id != current_user.id
        redirect_to blogs_path, notice: "権限がないため編集できません"
     end



  def update

    if @blog.update(blogs_params)
    redirect_to blogs_path
    else
     render 'edit'
    end
  end

  def destroy

    @blog.destroy
    redirect_to blogs_path, notice: "ブログを削除しました！"
  end

  def confirm
   @blog = Blog.new(blogs_params)
    render :new if @blog.invalid?
  end



   private
    def blogs_params
      params.require(:blog).permit(:title, :content)
    end
    def set_blog
      @blog = Blog.find(params[:id])
    end
end
