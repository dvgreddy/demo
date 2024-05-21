resource "google_storage_bucket" "static_site" {
  name                        = "test-static-bucket-usc1-01"
  location                    = "US"
  force_destroy               = true
  website {
    main_page_suffix = "index.html"
    not_found_page   = "error.html"
  }
}

resource "google_storage_bucket_iam_member" "bucket_policy" {
  bucket = google_storage_bucket.static_site.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket_object" "index" {
  name   = "index.html"
  bucket = google_storage_bucket.static_site.name
  source = "website/index.html"
  content_type = "text/html"
}

resource "google_storage_bucket_object" "errorfile" {
  name   = "error.html"
  bucket = google_storage_bucket.static_site.name
  source = "website/error.html"
  content_type = "text/html"
}

resource "google_compute_global_address" "static_site_ip" {
  name = "static-site-ip"
}

resource "google_compute_backend_bucket" "static_site_backend" {
  name   = "static-site-backend"
  bucket_name = google_storage_bucket.static_site.name
  enable_cdn = true
}

resource "google_compute_url_map" "static_site_url_map" {
  name            = "static-site-url-map"
  default_service = google_compute_backend_bucket.static_site_backend.id
}

resource "google_compute_target_http_proxy" "static_site_http_proxy" {
  name   = "static-site-http-proxy"
  url_map = google_compute_url_map.static_site_url_map.id
}

resource "google_compute_global_forwarding_rule" "static_site_forwarding_rule" {
  name       = "static-site-forwarding-rule"
  ip_address = google_compute_global_address.static_site_ip.address
  ip_protocol = "TCP"
  port_range  = "80"
  target      = google_compute_target_http_proxy.static_site_http_proxy.id
}
