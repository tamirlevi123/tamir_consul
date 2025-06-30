// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require foundation-sites
//= require jquery-ujs
//= require jquery-ui/ui/version
//= require jquery-ui/ui/data
//= require jquery-ui/ui/ie
//= require jquery-ui/ui/keycode
//= require jquery-ui/ui/position
//= require jquery-ui/ui/safe-active-element
//= require jquery-ui/ui/scroll-parent
//= require jquery-ui/ui/unique-id
//= require jquery-ui/ui/widget
//= require jquery-ui/ui/widgets/menu
//= require jquery-ui/ui/widgets/mouse
//= require jquery-ui/ui/widgets/datepicker
//= require jquery-ui/ui/i18n/datepicker-ar
//= require jquery-ui/ui/i18n/datepicker-bs
//= require jquery-ui/ui/i18n/datepicker-cs
//= require jquery-ui/ui/i18n/datepicker-da
//= require jquery-ui/ui/i18n/datepicker-de
//= require jquery-ui/ui/i18n/datepicker-el
//= require jquery-ui/ui/i18n/datepicker-es
//= require jquery-ui/ui/i18n/datepicker-fa
//= require jquery-ui/ui/i18n/datepicker-fr
//= require jquery-ui/ui/i18n/datepicker-gl
//= require jquery-ui/ui/i18n/datepicker-he
//= require jquery-ui/ui/i18n/datepicker-hr
//= require jquery-ui/ui/i18n/datepicker-id
//= require jquery-ui/ui/i18n/datepicker-it
//= require jquery-ui/ui/i18n/datepicker-nl
//= require jquery-ui/ui/i18n/datepicker-pl
//= require jquery-ui/ui/i18n/datepicker-pt-BR
//= require jquery-ui/ui/i18n/datepicker-ru
//= require jquery-ui/ui/i18n/datepicker-sl
//= require jquery-ui/ui/i18n/datepicker-sq
//= require jquery-ui/ui/i18n/datepicker-sv
//= require jquery-ui/ui/i18n/datepicker-zh-CN
//= require jquery-ui/ui/i18n/datepicker-zh-TW
//= require jquery-ui/ui/i18n/datepicker-en-GB
//= require jquery-ui/ui/widgets/autocomplete
//= require jquery-ui/ui/widgets/sortable
//= require blueimp-file-upload/js/jquery.iframe-transport
//= require blueimp-file-upload/js/jquery.fileupload
//= require foundation-sites
//= require turbolinks
//= require turbolinks_anchors
//= require ckeditor/loader
//= require_directory ./ckeditor
//= require social-share-button
//= require decision_tree
//= require app
//= require check_all_none
//= require comments
//= require foundation_extras
//= require location_changer
//= require moderator_comment
//= require moderator_debates
//= require moderator_proposals
//= require moderator_budget_investments
//= require moderator_proposal_notifications
//= require moderator_legislation_proposals
//= require gettext
//= require annotator
//= require legislation_annotatable
//= require jquery.amsify.suggestags
//= require tags
//= require participation_not_allowed
//= require advanced_search
//= require registration_form
//= require suggest
//= require forms
//= require valuation_budget_investment_form
//= require embed_video
//= require fixed_bar
//= require banners
//= require checkbox_toggle
//= require markdown-it/dist/markdown-it
//= require markdown_editor
//= require html_editor
//= require cocoon
//= require options
//= require questions
//= require legislation_admin
//= require legislation
//= require legislation_allegations
//= require legislation_draft_versions
//= require followable
//= require flaggable
//= require documentable
//= require imageable
//= require tree_navigator
//= require tag_autocomplete
//= require leaflet/dist/leaflet
//= require leaflet.markercluster/dist/leaflet.markercluster
//= require map
//= require polls
//= require sortable
//= require table_sortable
//= require investment_report_alert
//= require managers
//= require i18n
//= require_tree ./admin
//= require_tree ./sdg
//= require_tree ./sdg_management
//= require_tree ./custom
//= require custom

var initialize_modules = function() {
  "use strict";
  console.log("APPLICATION.JS: Starting.....");

  App.Options.initialize();
  App.Questions.initialize();
  App.Comments.initialize();
  App.ParticipationNotAllowed.initialize();
  App.Tags.initialize();
  console.log("APPLICATION.JS: 2");
  App.FoundationExtras.initialize();
  App.LocationChanger.initialize();
  App.CheckAllNone.initialize();
  App.AdvancedSearch.initialize();
  App.RegistrationForm.initialize();
  App.Suggest.initialize();
  App.Forms.initialize();
  App.ValuationBudgetInvestmentForm.initialize();
  App.EmbedVideo.initialize();
  App.FixedBar.initialize();
  console.log("APPLICATION.JS: 3");
  App.Banners.initialize();
  console.log("APPLICATION.JS: 3.1");
  if (App.SocialShare && typeof App.SocialShare.initialize === "function") {
    App.SocialShare.initialize();
  } else {
    console.warn("APPLICATION.JS: App.SocialShare is not defined. Skipping initialization.");
  }
  //App.SocialShare.initialize();
  console.log("APPLICATION.JS: 3.2");
  App.CheckboxToggle.initialize();
  console.log("APPLICATION.JS: 4");
  App.MarkdownEditor.initialize();
  console.log("APPLICATION.JS: 5");

  App.HTMLEditor.initialize();
  console.log("APPLICATION.JS: 6");

  App.LegislationAdmin.initialize();
  console.log("APPLICATION.JS: Before App.Legislation.initialize()");
  App.Legislation.initialize();
  console.log("APPLICATION.JS: Checking for .legislation-annotatable elements");
  console.log("APPLICATION.JS: Found", $(".legislation-annotatable").length, "elements");
  if ($(".legislation-annotatable").length) {
    console.log("APPLICATION.JS: Calling App.LegislationAnnotatable.initialize()");
    if (App.LegislationAnnotatable && typeof App.LegislationAnnotatable.initialize === "function") {
      App.LegislationAnnotatable.initialize();
    } else {
      console.error("APPLICATION.JS: App.LegislationAnnotatable or its initialize() is not defined!", App.LegislationAnnotatable);
    }
  } else {
    console.log("APPLICATION.JS: No .legislation-annotatable elements found");
  }
  console.log("APPLICATION.JS: 6.1");
  App.TreeNavigator.initialize();
  console.log("APPLICATION.JS: 6.2");
  App.Documentable.initialize();
  App.Imageable.initialize();
  console.log("APPLICATION.JS: 6.3");
  App.TagAutocomplete.initialize();
  console.log("APPLICATION.JS: 6.4");
  // App.Map.initialize();
  App.Polls.initialize();
  console.log("APPLICATION.JS: 6.5");
  App.Sortable.initialize();
  console.log("APPLICATION.JS: 6.6");
  App.TableSortable.initialize();
  console.log("APPLICATION.JS: 6.7");
  App.InvestmentReportAlert.initialize();
  console.log("APPLICATION.JS: 6.8");
  App.Managers.initialize();
  console.log("APPLICATION.JS: 6.9");
  if (App.Globalize && typeof App.Globalize.initialize === "function") {
    App.Globalize.initialize();
  } else {
    console.warn("APPLICATION.JS: App.Globalize is not defined. Skipping initialization.");
  }
  if (App.Settings && typeof App.Settings.initialize === "function") {
    App.Settings.initialize();
  } else {
    console.warn("APPLICATION.JS: App.Settings is not defined. Skipping initialization.");
  }
  if (typeof App.ColumnsSelector !== 'undefined' && $("#js-columns-selector").length && typeof App.ColumnsSelector.initialize === "function") {
    App.ColumnsSelector.initialize();
  } else if ($("#js-columns-selector").length) {
    console.warn("APPLICATION.JS: App.ColumnsSelector is not defined. Skipping initialization.");
  }
  console.log("APPLICATION.JS: 7");
  if (App.AdminBudgetsWizardCreationStep && typeof App.AdminBudgetsWizardCreationStep.initialize === "function") {
    App.AdminBudgetsWizardCreationStep.initialize();
  } else {
    console.warn("APPLICATION.JS: App.AdminBudgetsWizardCreationStep is not defined. Skipping initialization.");
  }
  if (App.AdminDashboardActionsForm && typeof App.AdminDashboardActionsForm.initialize === "function") {
    App.AdminDashboardActionsForm.initialize();
  } else {
    console.warn("APPLICATION.JS: App.AdminDashboardActionsForm is not defined. Skipping initialization.");
  }
  if (App.AdminMachineLearningScripts && typeof App.AdminMachineLearningScripts.initialize === "function") {
    App.AdminMachineLearningScripts.initialize();
  } else {
    console.warn("APPLICATION.JS: App.AdminMachineLearningScripts is not defined. Skipping initialization.");
  }
  if (App.AdminPollShiftsForm && typeof App.AdminPollShiftsForm.initialize === "function") {
    App.AdminPollShiftsForm.initialize();
  } else {
    console.warn("APPLICATION.JS: App.AdminPollShiftsForm is not defined. Skipping initialization.");
  }
  if (App.AdminTenantsForm && typeof App.AdminTenantsForm.initialize === "function") {
    App.AdminTenantsForm.initialize();
  } else {
    console.warn("APPLICATION.JS: App.AdminTenantsForm is not defined. Skipping initialization.");
  }
  if (App.AdminVotationTypesFields && typeof App.AdminVotationTypesFields.initialize === "function") {
    App.AdminVotationTypesFields.initialize();
  } else {
    console.warn("APPLICATION.JS: App.AdminVotationTypesFields is not defined. Skipping initialization.");
  }
  if (App.AdminMenu && typeof App.AdminMenu.initialize === "function") {
    App.AdminMenu.initialize();
  } else {
    console.warn("APPLICATION.JS: App.AdminMenu is not defined. Skipping initialization.");
  }
  console.log("APPLICATION.JS: 8");
  if (App.BudgetEditAssociations && typeof App.BudgetEditAssociations.initialize === "function") {
    App.BudgetEditAssociations.initialize();
  } else {
    console.warn("APPLICATION.JS: App.BudgetEditAssociations is not defined. Skipping initialization.");
  }
  //App.BudgetEditAssociations.initialize();
  console.log("APPLICATION.JS: 8.1");
  if (App.BudgetHideMoney && typeof App.BudgetHideMoney.initialize === "function") {
    App.BudgetHideMoney.initialize();
  } else {
    console.warn("APPLICATION.JS: App.BudgetHideMoney is not defined. Skipping initialization.");
  }
  if (App.Datepicker && typeof App.Datepicker.initialize === "function") {
    App.Datepicker.initialize();
  } else {
    console.warn("APPLICATION.JS: App.Datepicker is not defined. Skipping initialization.");
  }
  if (App.SDGRelatedListSelector && typeof App.SDGRelatedListSelector.initialize === "function") {
    App.SDGRelatedListSelector.initialize();
  } else {
    console.warn("APPLICATION.JS: App.SDGRelatedListSelector is not defined. Skipping initialization.");
  }
  if (App.SDGManagementRelationSearch && typeof App.SDGManagementRelationSearch.initialize === "function") {
    App.SDGManagementRelationSearch.initialize();
  } else {
    console.warn("APPLICATION.JS: App.SDGManagementRelationSearch is not defined. Skipping initialization.");
  }
  if (App.AuthenticityTokenRefresh && typeof App.AuthenticityTokenRefresh.initialize === "function") {
    App.AuthenticityTokenRefresh.initialize();
  } else {
    console.warn("APPLICATION.JS: App.AuthenticityTokenRefresh is not defined. Skipping initialization.");
  }
  if (App.CookiesConsent && typeof App.CookiesConsent.initialize === "function") {
    App.CookiesConsent.initialize();
  } else {
    console.warn("APPLICATION.JS: App.CookiesConsent is not defined. Skipping initialization.");
  }
  console.log("APPLICATION.JS: 9");
};

var destroy_non_idempotent_modules = function() {
  "use strict";

  App.ColumnsSelector.destroy();
  App.Datepicker.destroy();
  App.HTMLEditor.destroy();
  App.LegislationAnnotatable.destroy();
  // App.Map.destroy();
  App.SocialShare.destroy();
};

$(document).on("turbolinks:load", initialize_modules);
$(document).on("turbolinks:before-cache", destroy_non_idempotent_modules);
