
# require '/Users/wakayamayuki/workspace/JIHANKI/test.rb'
# vm = VendingMachine.new
require "pry"

class Product
  attr_accessor :product

  def initialize

    @product = [{name:"コーラ", price:120 , stock:5},
                {name:"レッドブル", price:200, stock:0},
                 {name:"水", price:100, stock:6}]

  end
end

class VendingMachine
  # ステップ０ お金の投入と払い戻しの例コード
  # ステップ１ 扱えないお金の例コード
  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  MONEY = [10, 50, 100, 500, 1000].freeze

  # （自動販売機に投入された金額をインスタンス変数の @slot_money に代入する）
  def initialize

    # 最初の自動販売機に入っている金額は0円
    @slot_money = 0

    stock = Product.new
    @products = stock.product

    #@products = [{name:"コーラ", price:120 , stock:5},{name:"レッドブル", price:200, stock:0}, {name:"水", price:100, stock:6}]

    @sales_amount = 0

    while 1==1

      do_something

    end
    # @stock = Stock.new

  end

  # 投入金額の総計を取得できる。
  def current_slot_money
    # 自動販売機に入っているお金を表示する
    @slot_money
  end

  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  # 投入は複数回できる。
  def slot_money(money)
    # 想定外のもの（１円玉や５円玉。千円札以外のお札、そもそもお金じゃないもの（数字以外のもの）など）
    # が投入された場合は、投入金額に加算せず、それをそのまま釣り銭としてユーザに出力する。
    if MONEY.include?(money)

      # 自動販売機にお金を入れる
      @slot_money += money
      return true
    else
      puts "この自販機が対応しているのは10円玉、50円玉、100円玉、500円玉、1000円札、5000円札のみです。"
      puts "それ以外の金額は入力しないでください。"

    end
  end

  def do_something

    keep_do=true

    while keep_do == true

      puts "何をしますか？"
      puts "0:お金を入れる。"
      puts "1:飲み物を買う。"
      puts "2:それ以外:終わる。"

      do_this = gets.chomp.to_s

      puts do_this

      case do_this
        when "0"
          #お金を入れるときの処理
          do_insert

        when "1"
          #飲み物を買う時の処理
          do_purchase

        when "2"
          #終了する時の処理
          return_money
          keep_do=false

        when "9"
          #管理者用隠しコマンド、状態確認
          p @products
          p @slot_money
          p @sales_amount

        when "99"
          #管理者用隠しコマンド、商品補充
          add_stock

        else
          puts "コマンド、[" + do_this.to_s + "]には対応していません。"
          puts "[0],[1],[2]のいずれかを選択してください。"
      end

    end

  end

  def add_stock
    # 商品名gets productsからさがす
    # あれあばそいついについか
    # # なければ新商品←show stock? あるものだけ追加でいいゆあ
    # puts "補充する商品名を入力してください"
    # product_name = gets.chomp

    puts "何を補充しますか？番号を入力してください"
    show_stock()#kari

    product = @products[gets.to_i]

    puts "何本補充しますか? 本数を入力してください"
    num = gets.to_i
    product[:stock] = (product[:stock] + num)
    puts product[:name] + "に" + num.to_s + "本補充しました。現在の在庫は" + product[:stock].to_s  + "本です。"

  end

  def do_insert

    puts "お金を入れてください"
    if slot_money(gets.to_i) == true
      puts "現在の投入金額は" + @slot_money.to_s + "円です。"
    end

  end

  def do_purchase
    puts "何を買いますか？番号を入力してください"
    show_stock()

    product = @products[gets.to_i]

    #  @products = [{name:"コーラ", price:120 , stock:5},{name:"レッドブル", price:200, stock:0}, {name:"水", price:100, stock:5}]

          msg = product[:name].to_s
          if product[:stock]<1

            puts msg + "は売り切れです。"

          else

            if product[:price]> @slot_money
              msg = msg + "を買うには" + ( product[:price] -@slot_money).to_s  + "円足りません。"
              puts msg
            else
              product[:stock] = (product[:stock] - 1)
              @slot_money -= product[:price].to_i
              @sales_amount += product[:price]

              msg = product[:price].to_s + "円の" + msg + "を購入しました。"
              puts msg

              go_roulette#ルーレット機能追加……あたりが出たらもう一本

              msg = "投入残額は"  + @slot_money.to_s + "円です。"
              puts msg
            end

          end

  end


  # 払い戻し操作を行うと、投入金額の総計を釣り銭として出力する。
  def return_money
    # 返すお金の金額を表示する
    puts @slot_money.to_s + "円返却します。"
    puts "ご利用ありがとうございました。"
    # 自動販売機に入っているお金を0円に戻す
    @slot_money = 0
  end

  def go_roulette
    puts "抽選を行います。"
    random = Random.new

    x=random.rand(1..2)#ランダム3桁が揃ったらあたり……ここの数値を変更することで確立調整可能
    puts "【" + x.to_s + "】"

    y=random.rand(1..2)
    puts "【" + y.to_s + "】"

    z=random.rand(1..2)
    puts "【" + z.to_s + "】"


    if x ==y && x == z
      puts "あたりが出たので、もう一本！"
      after_jackpot
    else
      puts "残念、外れです。"
    end

  end

  def after_jackpot
    #大当たり後の処理

    keep_do=false
    @products.each do |product|
      if product[:stock]>0
        keep_do=true
        break
      end
    end

    if keep_do==false
      puts "ごめんなさい。当たったけど商品がもうありません。"
    else
      puts "何をもらいますか？番号を入力してください。"
      show_stock

    end

    while keep_do==true

      product = @products[gets.to_i]

      msg = product[:name].to_s
      if product[:stock]<1

        puts msg + "は売り切れです。"
        puts "他の商品を選択してください。"

      else

        product[:stock] = (product[:stock] - 1)
        msg = "あたったので、" + msg + "をもらいました。"
        puts msg
        keep_do=false
      end

    end

  end



  def show_stock
    x = 0
    @products.each do |product|

      msg = x.to_s + product[:name].to_s

      if product[:stock]<1

        msg = msg + ":売り切れです。"

      else
        msg = msg + ":" + product[:price].to_s + "円です。"

        if product[:price]> @slot_money
          msg = msg + "……" + ( product[:price] -@slot_money).to_s  + "円足りません。"
        else
          msg = msg + "……購入可能です。"

        end

      end

      puts msg
      x += 1
    end
  end

end

# class Stock
#
#   def initialize
#     # 最初の在庫状態
#
#     @products = [{name:"コーラ", price:120 , stock:5}]
#
#
#   end
#
# end

vm = VendingMachine.new
