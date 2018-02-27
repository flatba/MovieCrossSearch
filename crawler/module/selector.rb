#
# 各動画サイトごとにCSSセレクターを用意
#
module Selector

  attr_reader :selector

  def setup_selector(site_name)

    if site_name == 'HULU'
      # def select_selector
        @selector = {
          :category_selector =>  'div.vod-frm--user01 > header > div > div > nav > ul > li > a',
          :content_click => 'body > div.vod-frm--user01 > main > div.vod-mod-content > div.vod-mod-tile > div > a',
          :thumbnail => 'body > div.vod-frm--user01 > main > div.vod-mod-key-visual > div > img',
          :title => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__information > div > div.vod-mod-detail-info02__header > h2',

          :original_title => '',
          :release_year => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__information > div > div.vod-mod-detail-info02__header > p > small',
          :running_time => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__information > div > div.vod-mod-detail-info02__movie > figure > figcaption > dl > dd',
          :summary => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__description > div.vod-mod-detail-info02__summary.vod-utl-brief-target.is-brief-closed > div > div.vod-mod-detail-info02__program-description > p',

          :genre => 'body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__information > div > div.vod-mod-detail-info02__header > div.vod-mod-detail-info02__navi > ul > li',
          :cast => 'div.vod-mod-detail-info02__credit-col:nth-child(1) > ul > li',
          :director => 'div.vod-mod-detail-info02__credit-col:nth-child(2) > ul:nth-child(4) > li > a'
        }
      # end
    elsif site_name == 'NETFLIX'
      # def select_selector
        @selector = {
          login: '//*[@id="appMountPoint"]/div/div[2]/div/div/form[1]/button',
          select_user: '//*[@id="appMountPoint"]/div/div/div[2]/div/div/ul/li[1]/div/a/div/div',
          category_selector: '#appMountPoint > div > div > div.pinning-header > div > div.main-header.has-billboard > ul',

          thumbnail: '',
          title: '',
          original_title: '',
          release_year: '',
          running_time: '',
          summary: '',
          genre: '',
          director: '',
          cast: ''
        }
      # end
    elsif site_name == 'AMAZON_PRIME'
      # def select_selector
        @selector = {
          thumbnail: '',
          title: '',
          original_title: '',
          release_year: '',
          running_time: '',
          summary: '',
          genre: '',
          director: '',
          cast: ''
        }
      # end
    elsif site_name == 'AMAZON_VIDEO'
      # def select_selector
        @selector = {
          thumbnail: '',
          title: '',
          original_title: '',
          release_year: '',
          running_time: '',
          summary: '',
          genre: '',
          director: '',
          cast: ''
        }
      # end
    elsif site_name == 'GYAO'
      # def select_selector
        @selector = {
          thumbnail: '',
          title: '',
          original_title: '',
          release_year: '',
          running_time: '',
          summary: '',
          genre: '',
          director: '',
          cast: ''
        }
      # end
    elsif site_name == 'DTV'
      # def select_selector
        @selector = {
          thumbnail: '',
          title: '',
          original_title: '',
          release_year: '',
          running_time: '',
          summary: '',
          genre: '',
          director: '',
          cast: ''
        }
      # end
    elsif site_name == 'UNEXT'
      # def select_selector
        @selector = {
          thumbnail: '',
          title: '',
          original_title: '',
          release_year: '',
          running_time: '',
          summary: '',
          genre: '',
          director: '',
          cast: ''
        }
      # end
    elsif site_name == 'APPLE_ITUNES'
      # def select_selector
        @selector = {
          thumbnail: '',
          title: '',
          original_title: '',
          release_year: '',
          running_time: '',
          summary: '',
          genre: '',
          director: '',
          cast: ''
        }
      # end
    elsif site_name == 'MICROSOFT'
      # def select_selector
        @selector = {
          thumbnail: '',
          title: '',
          original_title: '',
          release_year: '',
          running_time: '',
          summary: '',
          genre: '',
          director: '',
          cast: ''
        }
      # end
    elsif site_name == 'GOOGLEPLAY'
      # def select_selector
        @selector = {
          thumbnail: '',
          title: '',
          original_title: '',
          release_year: '',
          running_time: '',
          summary: '',
          genre: '',
          director: '',
          cast: ''
        }
      # end
    elsif site_name == 'MUBI'
      # def select_selector
        @selector = {
          thumbnail: '',
          title: '',
          original_title: '',
          release_year: '',
          running_time: '',
          summary: '',
          genre: '',
          director: '',
          cast: ''
        }
      # end
    end
  end
end
