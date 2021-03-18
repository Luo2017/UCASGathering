module StaticPagesHelper
  # 返回当前页面的名称
  def full_title(page_name = "")
    base_name = "果壳小聚"
    # 判断字符串是否为空
    if page_name.empty?
      base_name
    else
      "#{page_name} | #{base_name}"
    end
  end
end
