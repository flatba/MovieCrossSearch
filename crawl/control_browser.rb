# coding: utf-8
#
# ブラウザ操作全般
#
# require './crawl/selector.rb'

module ControlBrowser
  # include Selector

  # 新規タブを開いてハンドル（操作権）も新規タブに移動する
  def open_new_tab(driver)
    driver.execute_script("window.open()")
    driver.switch_to.window(driver.window_handles.last)
  end

  # 疑似キーボード操作で新規タブを開く
  def send_key_new_tab(element)
    element.send_keys(:command, :enter)
    sleep 3
  end

  # ハンドル（操作権）のみ移動する
  # def move_handle(driver)
  # end

  # 最後に開いたタブを閉じる（ハンドルを持つタブを閉じる）
  def close_new_tab(driver)
    driver.close
    driver.switch_to.window(driver.window_handles.last)
  end

  # 無限スクロールを動的にスクロールする
  def infinit_scroll(driver, sleep_time)
    body_dom_height = get_body_dom_height(driver)
    driver.execute_script('window.scrollTo(0, document.body.scrollHeight);')
    sleep 5
    new_body_dom_height = get_body_dom_height(driver)
    cnt = 1
    while body_dom_height != new_body_dom_height do
      body_dom_height = get_body_dom_height(driver)
      # puts '%{cnt}スクロール目' % { cnt: cnt }
      driver.execute_script('window.scrollTo(0, document.body.scrollHeight);')
      # スクロールがDOMのサイズ取得に追いついてしまって途中までしかスクロールしてない事象が起こり得るため、
      sleep sleep_time # スクロールするサイトによって調整する
      new_body_dom_height = get_body_dom_height(driver)
      cnt += 1
    end
  end

  def screenshot(driver)
    file_name = '_screenshot'
    extension = '.png'
    default_dir_path = '/Users/flatba/dev/project_ruby/movieCrossSearch/output/screenshot/'
    driver.save_screenshot default_dir_path + DateTime.now.strftime('%Y%m%d%H%M%S') + file_name + extension
  end

  private

  # bodyの高さを取得する（動的に変動する高さの取得に使用）
  def get_body_dom_height(driver)
    driver.find_element(:tag_name, 'body').size.height
  end
end
