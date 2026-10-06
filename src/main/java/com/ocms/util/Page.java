package com.ocms.util;

import java.util.List;

public class Page<T> {
    private List<T> items;
    private int page;
    private int pageSize;
    private int totalItems;
    private int totalPages;

    public Page(List<T> items, int page, int pageSize, int totalItems) {
        this.items = items;
        this.page = page;
        this.pageSize = pageSize;
        this.totalItems = totalItems;
        this.totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (this.totalPages == 0) this.totalPages = 1;
    }

    public List<T> getItems() { return items; }
    public int getPage() { return page; }
    public int getPageSize() { return pageSize; }
    public int getTotalItems() { return totalItems; }
    public int getTotalPages() { return totalPages; }
    public boolean hasPrevious() { return page > 1; }
    public boolean hasNext() { return page < totalPages; }
}
