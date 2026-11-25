module Paginatable
  extend ActiveSupport::Concern

  PER_PAGE = 10

  private

  def paginate(scope, per_page: PER_PAGE)
    @total_count = scope.unscope(:order).count
    @total_pages = [ (@total_count / per_page.to_f).ceil, 1 ].max
    @page = params[:page].to_i.clamp(1, @total_pages)
    scope.limit(per_page).offset((@page - 1) * per_page)
  end
end
