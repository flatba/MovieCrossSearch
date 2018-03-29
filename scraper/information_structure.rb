# 構造体に一度格納したほうがキレイかと思ったけど、書くの時間かかりそうだから一旦止める。
class InformationStructure
  attr_reader :struct

  def initialize(information_arr)
    @Infomarion = Struct.new(
      :thumnail,
      :title,
      :roginal_title,
      :release_year,
      :running_time,
      :summary,
      :poster_image,
      :genre,
      :cast,
      :director,
      :classification
      )
      @arr = information_arr
  end

  def set_item
    Infomarion.new()
  end
end