import React from 'react';
import {
  Header,
  HeaderName,
  HeaderGlobalBar,
  HeaderGlobalAction,
  Content,
  Theme,
} from '@carbon/react';
import { Catalog } from '@carbon/icons-react';
import SimpleArticleList from './components/SimpleArticleList';

const App: React.FC = () => {
  return (
    // theme="white" applies Carbon's white theme to all child components
    <Theme theme="white">
      <Header aria-label="SAMCO - Gestión de Artículos">
        <HeaderName href="/" prefix="SAMCO">
          Gestión de Artículos
        </HeaderName>
        <HeaderGlobalBar>
          <HeaderGlobalAction aria-label="Artículos" tooltipAlignment="end">
            <Catalog size={20} />
          </HeaderGlobalAction>
        </HeaderGlobalBar>
      </Header>

      <Content>
        <div style={{ maxWidth: '1200px', margin: '0 auto', padding: '2rem 1rem' }}>
          <h1 style={{ marginBottom: '1.5rem' }}>Gestión de Artículos</h1>
          <SimpleArticleList />
        </div>
      </Content>
    </Theme>
  );
};

export default App;
