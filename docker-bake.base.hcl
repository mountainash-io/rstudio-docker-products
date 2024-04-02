variable DRIVERS_VERSION {
    default = "2024.03.0"
}

function get_drivers_version {
    params = [os]
    result = os == "centos7" ? "${DRIVERS_VERSION}-1" : DRIVERS_VERSION
}

function get_drivers_version {
    params = [os]
    result = os == "centos7" ? "${DRIVERS_VERSION}-1" : DRIVERS_VERSION
}

variable BASE_BUILD_MATRIX {
    default = {
        builds = [
            {os = "centos7", r_primary = "4.2.0", r_alternate = "3.6.2", py_primary = "3.9.5", py_alternate = "3.8.10"},
            {os = "centos7", r_primary = "4.2.3", r_alternate = "4.1.3", py_primary = "3.9.14", py_alternate = "3.8.15"},
            {os = "ubuntu2204", r_primary = "4.2.0", r_alternate = "3.6.2", py_primary = "3.9.5", py_alternate = "3.8.10"},
            {os = "ubuntu2204", r_primary = "4.2.3", r_alternate = "4.1.3", py_primary = "3.9.14", py_alternate = "3.8.15"},
            {os = "ubuntu2204", r_primary = "4.2.3", r_alternate = "4.1.3", py_primary = "3.9.17", py_alternate = "3.8.17"},
            {os = "ubuntu2204", r_primary = "4.2.3", r_alternate = "4.1.3", py_primary = "3.12.1", py_alternate = "3.11.7"},
        ]
    }
}

variable PRO_BUILD_MATRIX {
    default = BASE_BUILD_MATRIX
}

group "default" {
    targets = [
        "product-base",
    ]
}

group "build-test-base" {
    targets = [
        "product-base",
        "test-product-base",
    ]
}

target "base" {
    labels = {
        "maintainer" = "Posit Docker <docker@posit.co>"
    }
}

target "product-base" {
    inherits = ["base"]
    target = "build"

    name = "product-base-${builds.os}-r${replace(builds.r_primary, ".", "-")}_${replace(builds.r_alternate, ".", "-")}-py${replace(builds.py_primary, ".", "-")}_${replace(builds.py_alternate, ".", "-")}"
    tags = [
        "ghcr.io/rstudio/product-base:${builds.os}-r${builds.r_primary}_${builds.r_alternate}-py${builds.py_primary}_${builds.py_alternate}",
        "docker.io/rstudio/product-base:${builds.os}-r${builds.r_primary}_${builds.r_alternate}-py${builds.py_primary}_${builds.py_alternate}",
    ]

    dockerfile = "Dockerfile.${builds.os}"
    context = "product/base"

    matrix = BASE_BUILD_MATRIX
    args = {
        R_VERSION = builds.r_primary
        R_VERSION_ALT = builds.r_alternate
        PYTHON_VERSION = builds.py_primary
        PYTHON_VERSION_ALT = builds.py_alternate
        TINI_VERSION = "0.19.0"
        QUARTO_VERSION = "1.3.340"
    }
}

target "test-product-base" {
    inherits = ["product-base-${builds.os}-r${replace(builds.r_primary, ".", "-")}_${replace(builds.r_alternate, ".", "-")}-py${replace(builds.py_primary, ".", "-")}_${replace(builds.py_alternate, ".", "-")}"]
    target = "test"

    name = "test-product-base-${builds.os}-r${replace(builds.r_primary, ".", "-")}_${replace(builds.r_alternate, ".", "-")}-py${replace(builds.py_primary, ".", "-")}_${replace(builds.py_alternate, ".", "-")}"

    dockerfile = "Dockerfile.${builds.os}"
    context = "product/base"

    matrix = BASE_BUILD_MATRIX
    args = {
        R_VERSION = builds.r_primary
        R_VERSION_ALT = builds.r_alternate
        PYTHON_VERSION = builds.py_primary
        PYTHON_VERSION_ALT = builds.py_alternate
        TINI_VERSION = "0.19.0"
        QUARTO_VERSION = "1.3.340"
    }
}