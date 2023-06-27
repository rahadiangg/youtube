module "local_module" {
  source = "../_base_modules"
}


// endswith() & startswith()
resource "local_file" "endswith" {
  content = <<EOF
// endswith() untuk check suffix dari sebuah string
${endswith("hello world", "world")}
${endswith("hello world", "hello")}

// startwith() untuk check suffix dari sebuah string
${startswith("hello world", "world")}
${startswith("hello world", "hello")}
  EOF

  filename = "${path.module}/endswith_startswith.txt"
}


// format()
variable "name_format" {
  type    = string
  default = "rahadiangg"
}

resource "local_file" "format" {
  content = <<EOF
// compose string dengan value

${format("hallo namaku %s", var.name_format)}
${format("aku punya %d motor dengan %d ban", 1, 3)}
  EOF

  filename = "${path.module}/format.txt"
}

// join() & split()
variable "list_join" {
  type    = list(string)
  default = ["pisang", "semangka", "salak"]
}

resource "local_file" "join_split" {
  content = <<EOF
// join() menggabungkan list of string menjadi satu

${join("-", var.list_join)}
${join("_", var.list_join)}


// split () menggunakan separator untuk mengubah string menjadi list
${join("|", split(",", "teh,kopi,gula"))}
  EOF

  filename = "${path.module}/join_split.txt"
}

// lower(), upper(), title()
resource "local_file" "lower_upper_title" {
  content = <<EOF
// lower() digunakana untuk mengubah string ke huruf kecil semua
${lower("MANTAP!!!")}

// upper() digunakana untuk mengubah string ke huruf kecil semua
${upper("djiwa")}

// title() digunakan untuk mengubah karakter pertama menjadi huruf besar
${title("belajar devops menyenangkan")}
  EOF

  filename = "${path.module}/lower_upper_title.txt"
}

// replace()

variable "string_replace" {
  type    = string
  default = "1 + 2 + 3"
}

resource "local_file" "replace" {
  content = <<EOF
// replace() digunakana mengubah sebagaian string jika match sesuai dengan yang didefinisikan
${replace(var.string_replace, "+", "-")}

  EOF

  filename = "${path.module}/replace.txt"
}

// strcontains()
resource "local_file" "strcontains" {
  content = <<EOF
// strcontains() cek apakah sebuah string mengandung potongan string yang didefinsikan
${strcontains("hello world", "wor")}

  EOF

  filename = "${path.module}/strcontains.txt"
}
