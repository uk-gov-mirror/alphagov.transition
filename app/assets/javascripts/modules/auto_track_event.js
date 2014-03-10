(function(Modules) {
  "use strict"

  Modules.AutoTrackEvent = function() {
    var that = this;
    that.start = function(element) {
      var action = element.data('track-action'),
          label = element.data('track-label'),
          value = element.data('track-value');

      GOVUK.track(action, label, value);
    }
  };

})(window.GOVUK.Modules);
