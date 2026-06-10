variable "location" {
  # Padrão da disciplina: eastus2 (também é onde o ML Workspace sobe sem
  # problemas; Brazil South costuma ser bloqueado em contas Azure for Students).
  description = "Região do Azure onde os recursos serão provisionados"
  type        = string
  default     = "eastus2"
}
