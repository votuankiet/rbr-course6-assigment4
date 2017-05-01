(function() {
  "use strict";

  angular
    .module("spa-demo.subjects")
    .factory("spa-demo.subjects.InquiriesAuthz", InquiriesAuthzFactory);

  InquiriesAuthzFactory.$inject = ["spa-demo.authz.Authz",
                                "spa-demo.authz.BasePolicy"];
  function InquiriesAuthzFactory(Authz, BasePolicy) {
    function InquiriesAuthz() {
      BasePolicy.call(this, "Inquiry");
    }

      //start with base class prototype definitions
    InquiriesAuthz.prototype = Object.create(BasePolicy.prototype);
    InquiriesAuthz.constructor = InquiriesAuthz;

      //override and add additional methods
    InquiriesAuthz.prototype.canCreate=function() {
      //console.log("ItemsAuthz.canCreate");
      return Authz.isAuthenticated();
    };

    //list
    InquiriesAuthz.prototype.canList = function(item) {
      //console.log("BasePolicy.canQuery");
      return Authz.isOrganizer(item);
    };

    //view
    InquiriesAuthz.prototype.canView = function(item) {
      //console.log("BasePolicy.canGetDetails", item);
      if (!item) {
        return false;
      } else {
        return !item.id ? this.canCreate() : (Authz.isOrganizer(item));
      }
    };

    return new InquiriesAuthz();
  }
})();