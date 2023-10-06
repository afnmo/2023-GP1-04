!function () {
    "use strict";
    var e = document.querySelector(".sidebar"),
        o = document.querySelectorAll("#sidebarToggle, #sidebarToggleTop");

    if (e) {
        e.querySelector(".collapse");
        var t = [].slice.call(document.querySelectorAll(".sidebar .collapse")).map((function (e) { return new bootstrap.Collapse(e, { toggle: !1 }) }));

        for (var l of o) l.addEventListener("click", (function (o) {
            if (document.body.classList.toggle("sidebar-toggled"), e.classList.toggle("toggled"), e.classList.contains("toggled"))
                for (var l of t) l.hide()
        })); window.addEventListener("resize",

            (function () {
                if (Math.max(document.documentElement.clientWidth || 0, window.innerWidth || 0) < 768)
                    for (var e of t) e.hide()
            }))
    }

    var n = document.querySelector("body.fixed-nav .sidebar");
    n && n.on("mousewheel DOMMouseScroll wheel", (

        function (e) {
            if (Math.max(document.documentElement.clientWidth || 0, window.innerWidth || 0) > 768) {
                var o = e.originalEvent, t = o.wheelDelta || -o.detail;
                this.scrollTop += 30 * (t < 0 ? 1 : -1), e.preventDefault()
            }
        }));
    var i = document.querySelector(".scroll-to-top");
    i && window.addEventListener("scroll", (function () { var e = window.pageYOffset; i.style.display = e > 100 ? "block" : "none" }))
}();