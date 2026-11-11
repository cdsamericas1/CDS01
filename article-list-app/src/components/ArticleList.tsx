import React, { useState, useMemo } from 'react';
import {
  DataTable,
  TableContainer,
  Table,
  TableHead,
  TableRow,
  TableHeader,
  TableBody,
  TableCell,
  TableToolbar,
  TableToolbarContent,
  TableToolbarSearch,
  Tag,
  Pagination,
} from '@carbon/react';
import type { Article } from '../types/article';

interface ArticleListProps {
  articles: Article[];
}

const PAGE_SIZE = 14; // Matches SAMCO SFLPAG=14

const VAT_LABELS: Record<string, { label: string; type: 'green' | 'blue' | 'gray' }> = {
  '2': { label: '20% Standard', type: 'blue' },
  '1': { label: '10% Reduced',  type: 'green' },
  '0': { label: '0% Zero',      type: 'gray' },
};

const headers = [
  { key: 'arid',     header: 'ID'          },
  { key: 'ardesc',   header: 'Description' },
  { key: 'artifa',   header: 'Family'      },
  { key: 'arsalepr', header: 'Sale Price'  },
  { key: 'arwhspr',  header: 'Stock Price' },
  { key: 'arstock',  header: 'Stock'       },
  { key: 'arminqty', header: 'Min. Stock'  },
  { key: 'arvatcd',  header: 'VAT'         },
];

const ArticleList: React.FC<ArticleListProps> = ({ articles }) => {
  const [page, setPage]           = useState(1);
  const [pageSize, setPageSize]   = useState(PAGE_SIZE);
  const [searchTerm, setSearchTerm] = useState('');

  // Filter active (non-deleted) articles matching the search term
  const filtered = useMemo(() => {
    const term = searchTerm.toLowerCase();
    return articles.filter(
      (a) =>
        a.ardel !== 'X' &&
        (a.ardesc.toLowerCase().includes(term) ||
          a.arid.includes(term) ||
          a.artifa.toLowerCase().includes(term))
    );
  }, [articles, searchTerm]);

  // Paginate filtered results
  const paginated = useMemo(() => {
    const start = (page - 1) * pageSize;
    return filtered.slice(start, start + pageSize);
  }, [filtered, page, pageSize]);

  // Build rows for Carbon DataTable
  const rows = paginated.map((a) => ({
    id:       a.arid,
    arid:     a.arid,
    ardesc:   a.ardesc,
    artifa:   a.artifa,
    arsalepr: `$${a.arsalepr.toFixed(2)}`,
    arwhspr:  `$${a.arwhspr.toFixed(2)}`,
    arstock:  (
      <span style={{ color: a.arstock <= a.arminqty ? '#da1e28' : 'inherit', fontWeight: a.arstock <= a.arminqty ? 600 : 400 }}>
        {a.arstock}
      </span>
    ),
    arminqty: a.arminqty,
    arvatcd:  (() => {
      const vat = VAT_LABELS[a.arvatcd] ?? { label: a.arvatcd, type: 'gray' as const };
      return <Tag type={vat.type}>{vat.label}</Tag>;
    })(),
  }));

  return (
    <DataTable rows={rows} headers={headers} isSortable>
      {({ rows: tableRows, headers: tableHeaders, getHeaderProps, getRowProps, getTableProps, onInputChange }) => (
        <TableContainer
          title="Articles"
          description={`${filtered.length} article${filtered.length !== 1 ? 's' : ''} found`}
        >
          <TableToolbar>
            <TableToolbarContent>
              <TableToolbarSearch
                placeholder="Search by ID, description or family..."
                onChange={(e) => {
                    onInputChange(e);
                    setSearchTerm((e as unknown as React.ChangeEvent<HTMLInputElement>).target.value);
                    setPage(1);
                  }}
              />
            </TableToolbarContent>
          </TableToolbar>

          <Table {...getTableProps()}>
            <TableHead>
              <TableRow>
                {tableHeaders.map((header) => (
                  <TableHeader {...getHeaderProps({ header })} key={header.key}>
                    {header.header}
                  </TableHeader>
                ))}
              </TableRow>
            </TableHead>
            <TableBody>
              {tableRows.map((row) => (
                <TableRow {...getRowProps({ row })} key={row.id}>
                  {row.cells.map((cell) => (
                    <TableCell key={cell.id}>{cell.value}</TableCell>
                  ))}
                </TableRow>
              ))}
            </TableBody>
          </Table>

          <Pagination
            totalItems={filtered.length}
            pageSize={pageSize}
            pageSizes={[14, 25, 50]}
            page={page}
            onChange={({ page: p, pageSize: ps }) => {
              setPage(p);
              setPageSize(ps);
            }}
          />
        </TableContainer>
      )}
    </DataTable>
  );
};

export default ArticleList;
