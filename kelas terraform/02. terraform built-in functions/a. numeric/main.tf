
module "local_module" {
  source = "../_base_modules"
}


// abs() functions

resource "local_file" "abs" {
  content = <<EOF
// ini adalah contoh penggunaan abs functions (a.k.a absolute)
${abs(23)}
${abs(0)}

// bilangan minus akan menjadi plus
${abs(-12.4)}
  EOF

  filename = "${path.module}/abs.txt"
}


// ceil() & floor() functions
resource "local_file" "ceil" {
  content = <<EOF
// ceil() membulatkan bilangan ke atas
${ceil(5)}
${ceil(5.1)}
${ceil(4.9)}

// floor() membulatkan bilangan ke bawah
${floor(5)}
${floor(5.1)}
${floor(4.9)}
  EOF

  filename = "${path.module}/ceil_floor.txt"
}


// max() & min() functions

variable "max_min_list" {
  type    = list(number)
  default = [1, 10, 3]
}

resource "local_file" "max" {
  content = <<EOF
// max() mencari nilai terbesar
${max(5, 45, 13)}

// max() format penulisan jika menggunakan tipe datanya adalas "list"
${max(var.max_min_list...)}

// min() mencari nilai terkecil
${min(5, 45, 13)}

// min() format penulisan jika menggunakan tipe datanya adalas "list"
${min(var.max_min_list...)}
  EOF

  filename = "${path.module}/max_min.txt"
}

// parseint()

resource "local_file" "paseint" {
  content = <<EOF
// convert string ke integer (desimal)
${parseint("100", 10)}

// convert string ke integer (hexadecimal)
${parseint("FF", 16)}

// convert string ke integer (binary)
${parseint("1011111011101111", 2)}

  EOF

  filename = "${path.module}/paseint.txt"
}