variable "location" {
  # Padrão da disciplina: eastus2. Brazil South costuma ser bloqueado pela
  # política "best available regions" das contas Azure for Students.
  description = "Região do Azure onde os recursos serão provisionados"
  type        = string
  default     = "eastus2"
}

variable "storage_account_aula2" {
  description = "Nome do Storage Account criado na Aula 2 (contém produtos.csv). Pegue com: cd ../../02-storage-bancos/lab/terraform && terraform output -raw storage_account_name"
  type        = string
}

variable "resource_group_aula2" {
  description = "Nome do Resource Group da Aula 2. Pegue com: terraform output -raw resource_group_name (na pasta da Aula 2)"
  type        = string
}

variable "aci_enabled" {
  description = "Quando true, provisiona o Azure Container Instances. Deixe false no primeiro apply (a imagem precisa ser pushed ao ACR antes do ACI subir)."
  type        = bool
  default     = false
}
