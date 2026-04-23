# frozen_string_literal: true

SimpleForm.setup do |config|
  config.error_notification_class = "alert alert-danger"
  config.button_class = "btn btn-primary"
  config.boolean_label_class = "form-check-label"
  config.browser_validations = false
  config.generate_additional_classes_for = []

  config.wrappers :vertical_form, class: "mb-3" do |b|
    b.use :html5
    b.use :placeholder
    b.optional :readonly

    b.use :label, class: "form-label"
    b.use :input, class: "form-control", error_class: "is-invalid", valid_class: "is-valid"
    b.use :full_error, wrap_with: { tag: :div, class: "invalid-feedback d-block" }
    b.use :hint, wrap_with: { tag: :div, class: "form-text" }
  end

  config.wrappers :vertical_select, class: "mb-3" do |b|
    b.use :html5
    b.optional :readonly

    b.use :label, class: "form-label"
    b.use :input, class: "form-select", error_class: "is-invalid", valid_class: "is-valid"
    b.use :full_error, wrap_with: { tag: :div, class: "invalid-feedback d-block" }
    b.use :hint, wrap_with: { tag: :div, class: "form-text" }
  end

  config.wrappers :vertical_boolean, class: "mb-3" do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper :form_check_wrapper, class: "form-check" do |ba|
      ba.use :input, class: "form-check-input", error_class: "is-invalid", valid_class: "is-valid"
      ba.use :label, class: "form-check-label"
    end

    b.use :full_error, wrap_with: { tag: :div, class: "invalid-feedback d-block" }
    b.use :hint, wrap_with: { tag: :div, class: "form-text" }
  end

  config.default_wrapper = :vertical_form

  config.wrapper_mappings = {
    boolean: :vertical_boolean,
    check_boxes: :vertical_boolean,
    date: :vertical_select,
    datetime: :vertical_select,
    file: :vertical_form,
    radio_buttons: :vertical_boolean,
    range: :vertical_form,
    select: :vertical_select,
    time: :vertical_select
  }
end
