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
} from '@carbon/react';
import { sampleArticles } from '../data/sampleArticles';

const headers = [
  { key: 'id',                header: 'ID'          },
  { key: 'description',       header: 'Description' },
  { key: 'familyDescription', header: 'Family'      },
  { key: 'salePrice',         header: 'Sale Price'  },
  { key: 'stock',             header: 'Stock'       },
];

const SimpleArticleList: React.FC = () => {
  const [search, setSearch] = useState('');

  // Filter rows by search term across ID, description and family
  const rows = useMemo(() => {
    const term = search.toLowerCase();
    return sampleArticles
      .filter(
        (a) =>
          a.id.toLowerCase().includes(term) ||
          a.description.toLowerCase().includes(term) ||
          a.familyDescription.toLowerCase().includes(term)
      )
      .map((a) => ({
        id:                a.id,
        description:       a.description,
        familyDescription: a.familyDescription,
        salePrice:         `$${a.salePrice.toFixed(2)}`,
        stock:             a.stock,
      }));
  }, [search]);

  return (
    <DataTable rows={rows} headers={headers} isSortable>
      {({ rows: tableRows, headers: tableHeaders, getHeaderProps, getRowProps, getTableProps }) => (
        <TableContainer
          title="Articles"
          description={`${rows.length} article${rows.length !== 1 ? 's' : ''}`}
        >
          <TableToolbar>
            <TableToolbarContent>
              <TableToolbarSearch
                placeholder="Search by ID, description or family..."
                onChange={(e) => setSearch((e as React.ChangeEvent<HTMLInputElement>).target.value)}
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
        </TableContainer>
      )}
    </DataTable>
  );
};

export default SimpleArticleList;
