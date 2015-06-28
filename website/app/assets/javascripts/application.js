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
//= require angular
//= require autocomplete-rails
//= require twitter/bootstrap
//= require_tree .
//= require chartkick

$.dynatableSetup({
    features: {
        paginate: true,
        sort: true,
        pushState: true,
        search: true,
        recordCount: true,
        perPageSelect: false
    },
    params: {
        sorts: 'order',
        page: 'page',
        perPage: 'per_page',
        queryRecordCount: 'count',
        totalRecordCount: 'total_count'
    },
    inputs: {
        queries: null,
        sorts: null,
        multisort: ['ctrlKey', 'shiftKey', 'metaKey'],
        page: null,
        queryEvent: 'blur change',
        searchText: 'Buscar: ',
        pageText: 'Paginas: ',
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
        processingText: 'Procesando...',
        recordCountTextTemplate: '{text} {pageTemplate} {totalTemplate}'
    }
});

(function() {
    var app = angular.module('SuitCase', []);
    app.controller('UserShowController', function() {
        var user_show = this;
        this.tab = 0;
        this.isTabActive = function(value) {
            return value === this.tab;
        };
        this.tabSelect = function(value) {
            this.tab = value;
        };
    });

    app.controller('CaseShowController', function() {
        var case_show = this;
        this.tab = 0;
        this.isTabActive = function(value) {
            return value === this.tab;
        };
        this.tabSelect = function(value) {
            this.tab = value;
        };
    });

    app.controller('UserShowCasesController', function() {
        this.user_id = $("#user_show_user_id").val();
        this.table = $('#user_show_cases_table');
        this.table.dynatable({
            dataset: {
                ajax: true,
                ajaxUrl: '/cases.json?user_id=' + this.user_id,
                ajaxOnLoad: true,
                records: [],
                perPageDefault: 15,
                perPageOptions: 15
            }
        });
        this.table.on('dynatable:afterUpdate', function() {
            connect_actions_case_buttons();
        });
    });


    app.controller('UserCasesController', function() {
        this.table = $('#user_cases_table');
        this.table.dynatable({
            dataset: {
                ajax: true,
                ajaxUrl: '/cases.json?only_user=true',
                ajaxOnLoad: true,
                records: [],
                perPageDefault: 15,
                perPageOptions: 15
            }
        });
        this.table.on('dynatable:afterUpdate', function() {
            connect_actions_case_buttons();
        });
    });
    app.controller('CasesController', function() {
        this.table = $('#cases_table');
        this.table.dynatable({
            dataset: {
                ajax: true,
                ajaxUrl: '/cases.json',
                ajaxOnLoad: true,
                records: [],
                perPageDefault: 15,
                perPageOptions: 15
            }
        });
        this.table.on('dynatable:afterUpdate', function() {
            connect_actions_case_buttons();
        });
    });
    app.controller('SearchController', function($http) {
        var search = this;
        search.rol = '';
        search.name = '';
        search.first_lastname = '';
        search.second_lastname = '';
        search.rut = '';
        search.buttonText = 'Buscar';
        search.working = false;
        search.show_table = false;
        search.id = null;
        search.table = $('.search_table');
        search.updateStatus = function () {
            $http.get("/searches/" + search.id + ".json")
                .success(function(response)
                {
                    if( response.state )
                    {
                        search.dejar_de_trabajar();
                    } else {
                        setTimeout(search.updateStatus, 1000 * 2);
                    }
                })
                .error(function() {
                    setTimeout(search.updateStatus, 1000 * 2);
                });
            // Llamamos cada 1 segundo
        };
        search.dejar_de_trabajar = function() {
            search.working = false;
            search.buttonText = 'Buscar';
        };
        search.empezar_a_trabajar = function() {
            search.working = true;
            search.buttonText = 'Buscando ...';
        };
        search.submit = function(){
            search.empezar_a_trabajar();
            search.table.dynatable({
                dataset: {
                    ajax: true,
                    ajaxUrl: '/cases.json',
                    ajaxOnLoad: true,
                    records: [],
                    perPageDefault: 15,
                    perPageOptions: 15
                }
            });
            search.table.on('dynatable:afterUpdate', function() {
                connect_actions_case_buttons();
            });
            search.show_table = true;
            // Creamos busqueda
            $http.post("/cases/searches.json",
                {
                    rol: search.rol,
                    name: search.name,
                    first_lastname: search.first_lastname,
                    second_lastname: search.second_lastname,
                    rut: search.rutect_
                } )
                .success(function(response) {
                    // Sacamos id para revisar estado
                    search.id = response.id;
                    search.updateStatus();
                });
        };
    });

    var connect_actions_case_buttons = function () {
        $('.form-add-record-case').on('ajax:success', function(e, data, status, xhr){
            $(this).addClass("hidden");
            var remove_form = $(this).siblings(".form-remove-record-case");
            remove_form.removeClass("hidden")
        }).on('ajax:error', function(e, xhr, status, error){
            alert("Error al agregar registro de seguimiento")
        });

        $('.form-remove-record-case').on('ajax:success', function(e, data, status, xhr){
            $(this).addClass("hidden");
            var add_form = $(this).siblings(".form-add-record-case");
            add_form.removeClass("hidden")
        }).on('ajax:error', function(e, xhr, status, error){
            alert("Error al agregar registro de seguimiento")
        });

        $('.form-add-user-case').on('ajax:success', function(e, data, status, xhr){
            $(this).addClass("hidden");
            var remove_form = $(this).siblings(".form-remove-user-case");
            remove_form.removeClass("hidden")
        }).on('ajax:error', function(e, xhr, status, error){
            alert("Error al agregar registro de seguimiento")
        });

        $('.form-remove-user-case').on('ajax:success', function(e, data, status, xhr){
            $(this).addClass("hidden");
            var add_form = $(this).siblings(".form-add-user-case");
            add_form.removeClass("hidden");
            // Si elimino user_case, se elimina record
            $(this).siblings('.form-remove-record-case').addClass("hidden");
            var add_form = $(this).siblings(".form-add-record-case");
            add_form.removeClass("hidden")
        }).on('ajax:error', function(e, xhr, status, error){
            alert("Error al agregar registro de seguimiento")
        });
    };

    $(document).on('ready page:load', function () {

        $('.table_generator').dynatable();

        connect_actions_case_buttons();

        $('#client_is_company').change(function() {
            $("#form-company-disappear").toggle()
        });

        $("#notifications").popover({
            'title' : 'Notificaciones',
            'html' : true,
            'placement' : 'right',
            'content' : $(".alert_list").html()
        });
    });
})();

