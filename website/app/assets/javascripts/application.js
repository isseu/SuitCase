// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/autocomplete
//= require autocomplete-rails
//= require twitter/bootstrap
//= require_tree .

$.dynatableSetup({
    features: {
        paginate: true,
        sort: true,
        pushState: true,
        search: true,
        recordCount: true,
        perPageSelect: false
    },
    inputs: {
        queries: null,
        sorts: null,
        multisort: ['ctrlKey', 'shiftKey', 'metaKey'],
        page: null,
        queryEvent: 'blur change',
        recordCountTarget: null,
        recordCountPlacement: 'after',
        paginationLinkTarget: null,
        paginationLinkPlacement: 'after',
        paginationPrev: 'Anterior',
        paginationNext: 'Siguiente',
        paginationGap: [1, 2, 2, 1],
        searchTarget: null,
        searchPlacement: 'before',
        perPageTarget: null,
        perPagePlacement: 'before',
        perPageText: 'Mostrar: ',
        recordCountText: 'Mostrando ',
        processingText: 'Procesando...'
    }
});

$(document).on('ready page:load', function () {

    $('.table').dynatable();

    $('.form-add-record-case').on('ajax:success', function(e, data, status, xhr){
        $(this).addClass("hidden")
        var remove_form = $(this).siblings(".form-remove-record-case")
        remove_form.removeClass("hidden")
    }).on('ajax:error', function(e, xhr, status, error){
        alert("Error al agregar registro de seguimiento")
    });

    $('.form-remove-record-case').on('ajax:success', function(e, data, status, xhr){
        $(this).addClass("hidden")
        var add_form = $(this).siblings(".form-add-record-case")
        add_form.removeClass("hidden")
    }).on('ajax:error', function(e, xhr, status, error){
        alert("Error al agregar registro de seguimiento")
    });

    $('.form-add-user-case').on('ajax:success', function(e, data, status, xhr){
        $(this).addClass("hidden")
        var remove_form = $(this).siblings(".form-remove-user-case")
        remove_form.removeClass("hidden")
    }).on('ajax:error', function(e, xhr, status, error){
        alert("Error al agregar registro de seguimiento")
    });

    $('.form-remove-user-case').on('ajax:success', function(e, data, status, xhr){
        $(this).addClass("hidden")
        var add_form = $(this).siblings(".form-add-user-case")
        add_form.removeClass("hidden")
    }).on('ajax:error', function(e, xhr, status, error){
        alert("Error al agregar registro de seguimiento")
    });

    $('#client_is_company').change(function() {
        $("#form-company-disappear").toggle()
    });

    $("#notifications").popover({
        'title' : 'Notificaciones',
        'html' : true,
        'placement' : 'right',
        'content' : $(".alert_list").html()
    });

})
