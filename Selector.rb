#
# CSSセレクターの記述のまとめ
# 各動画サイトごとにCSSセレクターを用意
#
class Selector

  def initialize(site_name)
    if site_name.include?('hulu')
      def selectSelector
        return @huluSelector = {
          :category_selector => 'div.vod-frm--user01 > header > div > div > nav > ul > li > a',
          :thumbnail_click => 'div.vod-utl-panel-opener',

          :thumbnail => 'body > div.vod-frm--user01 > main > div.vod-mod-key-visual > div > img',
          :title => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__information > div > div.vod-mod-detail-info02__header > h2',
          :original_title => '',
          :release_year => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__information > div > div.vod-mod-detail-info02__header > p > small',
          :genre => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__information > div > div.vod-mod-detail-info02__header > div.vod-mod-detail-info02__navi > ul > li',
          :running_time => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__information > div > div.vod-mod-detail-info02__movie > figure > figcaption > dl > dd',
          :directors => 'div.vod-mod-detail-info02__credit-col > ul',
          :casts => 'div.vod-mod-detail-info02__credit-col > ul',
          :summary => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__description > div.vod-mod-detail-info02__summary.vod-utl-brief-target.is-brief-closed > div > div.vod-mod-detail-info02__program-description > p'
        }
      end
    elsif site_name.include?('netflix')
      def selectSelector
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
    elsif site_name.include?('amazon_prime')
      def selectSelector
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
    elsif site_name.include?('amazon_video')
      def selectSelector
        return @amazonVideoSelector = {
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
    elsif site_name.include?('gyao')
      def selectSelector
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
    elsif site_name.include?('dtv')
      def selectSelector
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
    elsif site_name.include?('unext')
      def selectSelector
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
    elsif site_name.include?('apple_itunes')
      def selectSelector
        return @appleItunesSelector = {
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
    elsif site_name.include?('ms_video')
      def selectSelector
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
    elsif site_name.include?('googleplay')
      def selectSelector
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
    elsif site_name.include?('mubi')
      def selectSelector
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
  end
end