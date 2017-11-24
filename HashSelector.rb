class HashSelector

  def huluSelector
    puts "1-1"
    return @huluSelector = {
      :thumbnail_click => 'vod-mod-tray__thumbnail',
      :thumbnail => 'body > div.vod-frm--user01 > main > div.vod-mod-key-visual > div > img',
      :title => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__information > div > div.vod-mod-detail-info02__header > h2',
      :original_title => '',
      :release_year => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__information > div > div.vod-mod-detail-info02__header > p > small',
      :genre1 => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__information > div > div.vod-mod-detail-info02__header > div.vod-mod-detail-info02__navi > ul > li =>nth-child(1) > a',
      :genre2 => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__information > div > div.vod-mod-detail-info02__header > div.vod-mod-detail-info02__navi > ul > li:nth-child(2) > a',
      :genre3 => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__information > div > div.vod-mod-detail-info02__header > div.vod-mod-detail-info02__navi > ul > li:nth-child(3) > a',
      :running_time => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__information > div > div.vod-mod-detail-info02__movie > figure > figcaption > dl > dd',
      :director => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__description > div.vod-mod-detail-info02__summary.vod-utl-brief-target.is-brief-opened > div > div.vod-mod-detail-info02__credit > div:nth-child(1) > div:nth-child(2) > ul:nth-child(4) > li > a',
      :summary => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__description > div.vod-mod-detail-info02__summary.vod-utl-brief-target.is-brief-closed > div > div.vod-mod-detail-info02__program-description > p'
    }
  end

  def netflixSelector # Netflix 会員ID必要
    return @netflixSelector = {
      :thumbnail => '',
      :title => '',
      :original_title => '',
      :release_year => '',
      :genre => '',
      :running_time => '',
      :director => '',
      :summary => ''
    }
  end

  def amazonPrimeSelector
    return @amazonPrimeSelector = {
      :thumbnail => '',
      :title => '',
      :original_title => '',
      :release_year => '',
      :genre => '',
      :running_time => '',
      :director => '',
      :summary => ''
    }
  end

  def gyaoSelector
    return @gyaoSelector = {
      :thumbnail => '',
      :title => '',
      :original_title => '',
      :release_year => '',
      :genre => '',
      :running_time => '',
      :director => '',
      :summary => ''
    }
  end

  def dtvSelector
    return @dtvSelector = {
      :thumbnail => '',
      :title => '',
      :original_title => '',
      :release_year => '',
      :genre => '',
      :running_time => '',
      :director => '',
      :summary => ''
    }
  end

  def unextSelector
    return @unextSelector = {
      :thumbnail => '',
      :title => '',
      :original_title => '',
      :release_year => '',
      :genre => '',
      :running_time => '',
      :director => '',
      :summary => ''
    }
  end

  def appleItunesSelector
    return @unextSelector = {
      :thumbnail => '',
      :title => '',
      :original_title => '',
      :release_year => '',
      :genre => '',
      :running_time => '',
      :director => '',
      :summary => ''
    }
  end

  def microsoftSelector
    return @microsoftSelector = {
      :thumbnail => '',
      :title => '',
      :original_title => '',
      :release_year => '',
      :genre => '',
      :running_time => '',
      :director => '',
      :summary => ''
    }
  end

  def googleplaySelector
    return @googleplaySelector = {
      :thumbnail => '',
      :title => '',
      :original_title => '',
      :release_year => '',
      :genre => '',
      :running_time => '',
      :director => '',
      :summary => ''
    }
  end

  def mubiSelector
    return @mubiSelector = {
      :thumbnail => '',
      :title => '',
      :original_title => '',
      :release_year => '',
      :genre => '',
      :running_time => '',
      :director => '',
      :summary => ''
    }
  end

end
