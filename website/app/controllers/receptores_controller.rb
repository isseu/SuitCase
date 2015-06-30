class ReceptoresController < ApplicationController
  def index
    if not params[:case_id].nil?
      @case = Case.find(params[:case_id])
      if @case.info_type == InfoCivil.to_s
        @receptores = @case.info.receptors
        return
      else
        render :json => 'Caso no existe'
        return
      end
    end
    render :json => 'El caso no es de civil por lo que no tiene retiros de receptores'
    return
  end
end
