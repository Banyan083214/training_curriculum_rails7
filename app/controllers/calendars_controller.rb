class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params

    params.require(:plan).permit(:date, :plan)

  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
  
    # Dateオブジェクトは、日付を保持しています。
    @todays_date = Date.today
    # 今日が何曜日かを取得
    today_wday = @todays_date.wday
  
    @week_days = []
  
    plans = Plan.where(date: @todays_date..@todays_date + 6)
  
    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end


      days = {
        :weekday => wdays[(today_wday + x) % 7], # 正しい曜日を取得するように修正
        :month => (@todays_date + x).month,
        :date => (@todays_date + x).day,
        :plans => today_plans
      }
      puts "DEBUG: days = #{days.inspect}"

      @week_days.push(days)
    end
  end
end